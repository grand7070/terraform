locals {
    az_num = length(var.availability_zones)
    az_name = local.az_num == 2 ? ["a", "c"] : local.az_num == 3 ? ["a", "b", "c"] : local.az_num == 4 ? ["a", "b", "c", "d"] : []
    default_cidr = "0.0.0.0/0"
}

# vpc
resource "aws_vpc" "vpc" {
    cidr_block           = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
        Name = "${var.env}-vpc"
    }
}

# subnet
## public subnet
resource "aws_subnet" "web_pub" {
    count                   = local.az_num
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index)
    availability_zone       = element(var.availability_zones, count.index)
    map_public_ip_on_launch = true
    
    tags = {
        Name = "${var.env}-web-pub-${local.az_name[count.index]}"
        Description = "public subnet for web"
    }
}

## private subnet
resource "aws_subnet" "app_prv" {
    count                   = local.az_num
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index + 4)
    availability_zone       = element(var.availability_zones, count.index)

    tags = {
        Name = "${var.env}-app-prv-${local.az_name[count.index]}"
        Description = "private subnet for application"
    }
}

resource "aws_subnet" "db_prv" {
    count                   = local.az_num
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index + 8)
    availability_zone       = element(var.availability_zones, count.index)

    tags = {
        Name = "${var.env}-db-prv-${local.az_name[count.index]}"
        Description = "private subnet for database"
    }
}

# internet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.env}-igw"
    }
}

# eip
resource "aws_eip" "ngw_ip" {
    # vpc   = true

    lifecycle {
        create_before_destroy = true
    }
}

# nat gateway
resource "aws_nat_gateway" "ngw" {
    allocation_id = aws_eip.ngw_ip.id
    subnet_id     = aws_subnet.web_pub[0].id

    tags = {
        Name = "${var.env}-ngw"
    }
}

# route table
resource "aws_route_table" "web_pub_rt" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = local.default_cidr
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "public web route table"
    }
}

resource "aws_route_table" "prv_app_rt" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = local.default_cidr
        nat_gateway_id = aws_nat_gateway.ngw.id
    }

    tags = {
        Name = "private application route table"
    }
}

resource "aws_route_table" "prv_db_rt" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "private db route table"
    }
}

resource "aws_route_table_association" "web_pub_rta" {
    count          = local.az_num
    subnet_id      = element(aws_subnet.web_pub[*].id, count.index)
    route_table_id = aws_route_table.web_pub_rt.id
}

resource "aws_route_table_association" "app_prv_rta" {
    count          = local.az_num
    subnet_id      = element(aws_subnet.app_prv[*].id, count.index)
    route_table_id = aws_route_table.prv_app_rt.id
}

resource "aws_route_table_association" "db_prv_rta_a" {
    count          = local.az_num
    subnet_id      = element(aws_subnet.db_prv[*].id, count.index)
    route_table_id = aws_route_table.prv_db_rt.id
}

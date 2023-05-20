resource "aws_route_table" "pub_rt" {
    vpc_id = aws_vpc.vpc.id
		route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "public route table"
    }
}

resource "aws_route_table" "prv_app_rt" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
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
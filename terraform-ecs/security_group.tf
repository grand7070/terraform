resource "aws_security_group" "exlb_sg" {
    name        = "exlb_sg"
    description = "security group for external load balancer"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description = "For https port"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "exlb_sg"
    }
}

resource "aws_security_group" "bastion_sg" {
    name        = "bastion_sg"
    description = "security group for bastion"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description = "For ssh port"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [local.my_ip]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "bastion_sg"
    }
}

resource "aws_security_group" "app_sg" {
    name        = "app_sg"
    description = "security group for application"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description = "For dynamic port"
        from_port   = 32768
        to_port     = 61000
        protocol    = "tcp"
				security_groups = [aws_security_group.exlb_sg.id]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "app_sg"
    }
}

resource "aws_security_group" "db_sg" {
    name        = "db_sg"
    description = "security group for database"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description = "For database"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
				security_groups = [
					aws_security_group.bastion_sg.id,
					aws_security_group.app_sg.id
				]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "db_sg"
    }
}

resource "aws_security_group" "redis_sg" {
    name        = "redis_sg"
    description = "security group for redis"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description = "For redis"
        from_port   = 6379
        to_port     = 6379
        protocol    = "tcp"
				security_groups = [aws_security_group.app_sg.id]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "redis_sg"
    }
}

resource "aws_security_group" "endpoint_sg" {
    name        = "endpoint_sg"
    description = "security group for endpoint"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description = "For endpoint"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
				security_groups = [aws_security_group.app_sg.id]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "endpoint_sg"
    }
}
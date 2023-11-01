locals {
    default_ingress = {
        description = "for https port"
        protocol    = "tcp"
        from_port   = 80
        to_port     = 80
        cidr_blocks = ["0.0.0.0/0"]
    }

    default_egress = {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_security_group" "external_alb_sg" {
    name        = "external_alb_sg"
    description = "security group for external load balancer"
    vpc_id      = var.vpc_id

    ingress {
        description = local.default_ingress.description
        protocol    = local.default_ingress.protocol
        from_port   = local.default_ingress.from_port
        to_port     = local.default_ingress.to_port
        cidr_blocks = local.default_ingress.cidr_blocks
    }

    egress {
        protocol    = local.default_egress.protocol
        from_port   = local.default_egress.from_port
        to_port     = local.default_egress.to_port
        cidr_blocks = local.default_egress.cidr_blocks
    }

    tags = {
        Name = "external_alb_sg"
    }
}

resource "aws_security_group" "web_sg" {
    name        = "web_sg"
    description = "security group for web"
    vpc_id      = var.vpc_id

    ingress {
        description = "for external lb port"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups = [aws_security_group.external_alb_sg.id]
    }

    egress {
        protocol    = local.default_egress.protocol
        from_port   = local.default_egress.from_port
        to_port     = local.default_egress.to_port
        cidr_blocks = local.default_egress.cidr_blocks
    }

    tags = {
        Name = "app_sg"
    }
}

resource "aws_security_group" "internal_alb_sg" {
    name        = "internal_alb_sg"
    description = "security group for internal load balancer"
    vpc_id      = var.vpc_id

    ingress {
        description = local.default_ingress.description
        protocol    = local.default_ingress.protocol
        from_port   = 8080
        to_port     = 8080
        security_groups = [aws_security_group.web_sg.id]
    }

    egress {
        protocol    = local.default_egress.protocol
        from_port   = local.default_egress.from_port
        to_port     = local.default_egress.to_port
        cidr_blocks = local.default_egress.cidr_blocks
    }

    tags = {
        Name = "internal_lb_sg"
    }
}

resource "aws_security_group" "app_sg" {
    name        = "app_sg"
    description = "security group for application"
    vpc_id      = var.vpc_id

    ingress {
        description = "For internal lb port"
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        security_groups = [aws_security_group.internal_alb_sg.id]
    }

    egress {
        protocol    = local.default_egress.protocol
        from_port   = local.default_egress.from_port
        to_port     = local.default_egress.to_port
        cidr_blocks = local.default_egress.cidr_blocks
    }

    tags = {
        Name = "app_sg"
    }
}

resource "aws_security_group" "db_sg" {
    name        = "db_sg"
    description = "security group for database"
    vpc_id      = var.vpc_id

    ingress {
        description = "For database"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups = [aws_security_group.app_sg.id]
    }

    egress {
        protocol    = local.default_egress.protocol
        from_port   = local.default_egress.from_port
        to_port     = local.default_egress.to_port
        cidr_blocks = local.default_egress.cidr_blocks
    }

    tags = {
        Name = "db_sg"
    }
}
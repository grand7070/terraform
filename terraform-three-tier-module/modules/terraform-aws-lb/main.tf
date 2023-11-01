locals {
    alb_type = "application"
    http_web_port = 80
    http_nginx_port = 80
    http_app_port = 8080
    http_tomcat_port = 8080
    http_protocol = "HTTP"
}

resource "aws_lb_target_group" "web_tg" {
    name     = "web-tg"
    port     = local.http_nginx_port
    protocol = local.http_protocol
    vpc_id   = var.vpc_id

    health_check {
        enabled             = true
        interval            = 120
        path                = "/"
        port                = "traffic-port"
        protocol            = local.http_protocol
        timeout             = 60
        healthy_threshold   = 3
        unhealthy_threshold = 5
    }
}

resource "aws_lb" "external_alb" {
    load_balancer_type               = local.alb_type

    name                             = "external-alb" 
    internal                         = false
    ip_address_type                  = "ipv4"

    subnets                          = var.web_public_subnet_ids
    enable_cross_zone_load_balancing = true
    security_groups                  = [var.external_alb_security_group_id]
}

resource "aws_lb_listener" "external_lb_listener" {
    load_balancer_arn    = aws_lb.external_alb.arn
    port                 = local.http_web_port
    protocol             = local.http_protocol

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.web_tg.arn
    }
}

resource "aws_lb_target_group" "app_tg" {
    name     = "app-tg"
    port     = local.http_tomcat_port
    protocol = local.http_protocol
    vpc_id   = var.vpc_id

    health_check {
        enabled             = true
        interval            = 120
        path                = "/"
        port                = "traffic-port"
        protocol            = local.http_protocol
        timeout             = 60
        healthy_threshold   = 3
        unhealthy_threshold = 5
    }
}

resource "aws_lb" "internal_alb" {
    load_balancer_type = local.alb_type

    name               = "my-internal-alb" 
    internal            = true
    ip_address_type = "ipv4"

    subnets = var.app_private_subnet_ids
    enable_cross_zone_load_balancing = true
    security_groups    = [var.internal_alb_security_group_id]
}

resource "aws_lb_listener" "internal_lb_listener" {
    load_balancer_arn = aws_lb.internal_alb.arn
    port              = local.http_app_port
    protocol          = local.http_protocol

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.app_tg.arn
    }
}

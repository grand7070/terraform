output "web_target_group_arn" {
    value = aws_lb_target_group.web_tg.arn
}

output "app_target_group_arn" {
    value = aws_lb_target_group.app_tg.arn
}

output "internal_alb_dns_name" {
    value = aws_lb.internal_alb.dns_name
}
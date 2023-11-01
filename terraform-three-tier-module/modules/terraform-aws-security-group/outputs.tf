output "external_alb_security_group_id" {
    value = aws_security_group.external_alb_sg.id
}

output "web_security_group_id" {
    value = aws_security_group.web_sg.id
}

output "internal_alb_security_group_id" {
    value = aws_security_group.internal_alb_sg.id
}

output "app_security_group_id" {
    value = aws_security_group.app_sg.id
}

output "db_security_group_id" {
    value = aws_security_group.db_sg.id
}

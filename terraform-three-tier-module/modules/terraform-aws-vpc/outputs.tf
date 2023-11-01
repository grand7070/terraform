output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "web_public_subnet_ids" {
    value = aws_subnet.web_pub[*].id
}

output "app_private_subnet_ids" {
    value = aws_subnet.app_prv[*].id
}

output "db_private_subnet_ids" {
    value = aws_subnet.db_prv[*].id
}
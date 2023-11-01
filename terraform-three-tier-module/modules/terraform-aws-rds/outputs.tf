output "rds_address" {
    value = aws_db_instance.rds.address
}

output "rds_name" {
    value = aws_db_instance.rds.db_name
}

output "rds_username" {
    value = aws_db_instance.rds.username
}

output "rds_password" {
    value = aws_db_instance.rds.password
}
locals {
    utf8mb4 = "utf8mb4"
    utf8mb4_general_ci = "utf8mb4_general_ci"
    parameters = [
        { name = "character_set_client",       value = local.utf8mb4 },
        { name = "character_set_connection",   value = local.utf8mb4 },
        { name = "character_set_database",     value = local.utf8mb4 },
        { name = "character_set_filesystem",   value = local.utf8mb4 },
        { name = "character_set_results",      value = local.utf8mb4 },
        { name = "character_set_server",       value = local.utf8mb4 },
        { name = "collation_connection",       value = local.utf8mb4_general_ci },
        { name = "collation_server",           value = local.utf8mb4_general_ci },
        { name = "time_zone",                  value = "Asia/Seoul" }
    ]
}

resource "aws_db_parameter_group" "rds_parameter_group" {
    family      = "mysql8.0"
    name        = "rds-parameter-group"
    description = "rds parameter group"

    dynamic "parameter" {
        for_each = local.parameters

        content {
            name  = parameter.value.name
            value = parameter.value.value
        }
    }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
    name       = "rds_subnet_group"
    subnet_ids = var.db_public_subnet_ids

    tags = {
        Name = "RDS subnet group"
    }
}

resource "aws_db_instance" "rds" {
    engine         = "mysql"
    engine_version = "8.0"

    identifier = "database"
    username   = "admin"
    password   = "12345678" # TODO

    instance_class = "db.t2.micro"

    storage_type      = "gp2"
    allocated_storage = 20

    db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
    vpc_security_group_ids = [var.db_security_group_id]

    db_name = "first_db"
    parameter_group_name = aws_db_parameter_group.rds_parameter_group.name

    skip_final_snapshot = true

    tags = {
        Name = "RDS"
    }
}
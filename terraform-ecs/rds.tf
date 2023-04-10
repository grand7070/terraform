resource "aws_db_instance" "rds" {
  engine               = "mysql"
  engine_version       = "8.0"

  identifier           = "database"
  username             = "admin"
  password             = "12345678"

  instance_class       = "db.t2.micro"

  storage_type         = "gp2"
  allocated_storage    = 20

  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  parameter_group_name = aws_db_parameter_group.rds_parameter_group.name

  skip_final_snapshot = true

  tags = {
    Name = "RDS"
  }
}
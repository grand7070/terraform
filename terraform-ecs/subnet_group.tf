resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.db_prv_a.id, aws_subnet.db_prv_c.id]

  tags = {
    Name = "RDS subnet group"
  }
}
# external load balancer security group
resource "aws_security_group" "exlb_sg" {
  name        = "exlb-sg"
  description = "security group for external load balancer"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "For http port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "For https port"
    from_port   = 443
    to_port     = 443
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
    Name = "exlb-sg"
  }
}

# application security group
resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "security group for application"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "For application"
    from_port   = 8080
    to_port     = 8080
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
    Name = "app-sg"
  }
}

# db security group
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "security group for database"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "For database"
    from_port   = 3306
    to_port     = 3306
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
    Name = "db-sg"
  }
}
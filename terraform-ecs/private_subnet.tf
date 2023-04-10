resource "aws_subnet" "app_prv_a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.10.101.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "app-prv-a"
    Description = "application"
  }
}

resource "aws_subnet" "app_prv_c" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.10.102.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "app-prv-c"
    Description = "application"
  }
}

resource "aws_subnet" "db_prv_a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.10.103.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "db-prv-a"
    Description = "database"
  }
}

resource "aws_subnet" "db_prv_c" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.10.104.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "db-prv-c"
    Description = "database"
  }
}
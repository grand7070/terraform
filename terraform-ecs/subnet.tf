resource "aws_subnet" "pub_a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "pub-a"
    Description = "public subnet"
  }
}

resource "aws_subnet" "pub_c" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "pub-c"
    Description = "public subnet"
  }
}

resource "aws_subnet" "app_prv_a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.8.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "app-prv-a"
    Description = "application"
  }
}

resource "aws_subnet" "app_prv_c" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.9.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "app-prv-c"
    Description = "application"
  }
}

resource "aws_subnet" "db_prv_a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "db-prv-a"
    Description = "database"
  }
}

resource "aws_subnet" "db_prv_c" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.11.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "db-prv-c"
    Description = "database"
  }
}
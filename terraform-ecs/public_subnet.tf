resource "aws_subnet" "exlb_pub_a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.10.1.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "exlb-pub-a"
    Description = "external-lb"
  }
}

resource "aws_subnet" "exlb_pub_c" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.10.2.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "exlb-pub-c"
    Description = "external-lb"
  }
}
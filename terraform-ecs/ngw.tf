resource "aws_eip" "ngw_ip" {
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw_ip.id
  subnet_id     = aws_subnet.exlb_pub_a.id

  tags = {
    Name = "NAT Gateway"
  }
}
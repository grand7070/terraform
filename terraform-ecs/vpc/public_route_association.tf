resource "aws_route_table_association" "exlb_pub_rta_a" {
  subnet_id      = aws_subnet.exlb_pub_a.id
  route_table_id = aws_default_route_table.public_rt.id
}

resource "aws_route_table_association" "exlb_pub_rta_c" {
  subnet_id      = aws_subnet.exlb_pub_c.id
  route_table_id = aws_default_route_table.public_rt.id
}
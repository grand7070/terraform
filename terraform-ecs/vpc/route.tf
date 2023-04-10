resource "aws_route" "private_rt_route" {
  route_table_id              = aws_route_table.private_rt.id
  destination_cidr_block      = "0.0.0.0/0"
  nat_gateway_id              = aws_nat_gateway.ngw.id
}
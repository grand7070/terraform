resource "aws_route_table_association" "pub_rta_a" {
    subnet_id      = aws_subnet.pub_a.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "pub_rta_c" {
    subnet_id      = aws_subnet.pub_c.id
    route_table_id = aws_route_table.public_rt.id
}

# private associate
resource "aws_route_table_association" "app_prv_rta_a" {
    subnet_id      = aws_subnet.app_prv_a.id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "app_prv_rta_c" {
    subnet_id      = aws_subnet.app_prv_c.id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "db_prv_rta_a" {
    subnet_id      = aws_subnet.db_prv_a.id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "db_prv_rta_c" {
    subnet_id      = aws_subnet.db_prv_c.id
    route_table_id = aws_route_table.private_rt.id
}
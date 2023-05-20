resource "aws_instance" "bastion" {
  ami = "ami-027ce4ce0590e3c98"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.pub_a.id
  key_name = "bastion-key-pair"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
	associate_public_ip_address = true

  tags = {
    "Name" = "bastion"
  }
}
resource "aws_launch_template" "eks_launch_template" {
  name = "eks_launch_template"

  instance_type = "t3.medium"
  vpc_security_group_ids = [aws_security_group.node_group_sg.id]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 20
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }
}
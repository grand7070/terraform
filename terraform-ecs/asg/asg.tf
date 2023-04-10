resource "aws_autoscaling_group" "autoscaling_group" {
  name                 = "autoscaling_group"
  min_size             = 1  # 최소 인스턴스 갯수
  max_size             = 1  # 최대 인스턴스 갯수
  desired_capacity     = 1  # 원하는 인스턴스 갯수

  availability_zones = [
    aws_subnet.app_prv_a.availability_zone,
    aws_subnet.app_prv_c.availability_zone,
  ]

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}
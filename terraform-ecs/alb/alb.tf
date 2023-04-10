resource "aws_lb" "exlb" {
  name               = "exlb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.exlb_sg.id]
  subnets            = [
    aws_subnet.exlb_pub_a.id,
    aws_subnet.exlb_pub_c.id,
  ]
}

resource "aws_lb_target_group" "exlb_app_tg" {
  name     = "exlb_app_tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    enabled             = true
    interval            = 15
    path                = "/actuator/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.exlb.arn
  port              = 80 # 443
  protocol          = "HTTP" # "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.exlb_app_tg.arn
  }
}
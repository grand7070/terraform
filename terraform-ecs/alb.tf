resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    enabled             = true
    interval            = 60
    # path                = "/actuator/health"
    path = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 30
    healthy_threshold   = 3
    unhealthy_threshold = 5
  }
}

resource "aws_lb" "exlb" {
  load_balancer_type = "application"

  name               = "exlb"
  internal           = false
	ip_address_type = "ipv4"

  subnets            = [
		aws_subnet.pub_a.id,
		aws_subnet.pub_c.id,
	]

  security_groups    = [aws_security_group.exlb_sg.id]
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.exlb.arn
  port              = 80 # 443
  protocol          = "HTTP" # "HTTPS"

	# ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  # certificate_arn   = aws_lb_listener_certificate.exlb_listener_certificate.arn # ?
	# certificate_arn   = "${data.aws_acm_certificate.example_dot_com.arn}"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# resource "aws_lb_listener_certificate" "exlb_listener_certificate" {
#   listener_arn    = aws_lb_listener.app_listener.arn
#   certificate_arn = aws_acm_certificate.example.arn
# }
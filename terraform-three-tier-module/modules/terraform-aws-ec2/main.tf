locals {
  ami = "ami-09af799f87c7601fa"
  t2_micro = "t2.micro"
  default_block = {
    device_name = "/dev/xvda"
    volume_size = 30
    volume_type = "gp2"
  }
  default_size = {
    min_size = 2
    max_size = 2
    desired_capacity = 2
  }
}

resource "aws_launch_template" "web_launch_template" {
  name   = "web_launch_template"
  image_id      = local.ami
  instance_type = local.t2_micro

  vpc_security_group_ids = [var.web_security_group_id]

  block_device_mappings {
    device_name = local.default_block.device_name
  
    ebs {
      volume_size = local.default_block.volume_size
      volume_type = local.default_block.volume_type
    }
  }

  user_data = base64encode(templatefile("../../scripts/web_user_data.sh", {
    INTERNAL_ALB_DNS_NAME = var.internal_alb_dns_name
  }))

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_autoscaling_group" {
  name                 = "web_autoscaling_group"
  min_size             = local.default_size.min_size
  max_size             = local.default_size.max_size
  desired_capacity     = local.default_size.desired_capacity

  vpc_zone_identifier = var.web_public_subnet_ids

  target_group_arns = [var.web_target_group_arn]
  # depends_on = [aws_lb_target_group.web_tg] TODO

  launch_template {
    id      = aws_launch_template.web_launch_template.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "app_launch_template" {
  name   = "app_launch_template"
  image_id      = local.ami
  instance_type = local.t2_micro

  vpc_security_group_ids = [var.app_security_group_id]

  block_device_mappings {
    device_name = local.default_block.device_name
  
    ebs {
      volume_size = local.default_block.volume_size
      volume_type = local.default_block.volume_type
    }
  }

  user_data = base64encode(templatefile("../../scripts/app_user_data.sh", {
    DB_ADDRESS = var.db_address
    DB_NAME = var.db_name
    DB_USERNAME = var.db_username
    DB_PASSWORD = var.db_password
  }))

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app_autoscaling_group" {
  name                 = "app_autoscaling_group"
  min_size             = local.default_size.min_size
  max_size             = local.default_size.max_size
  desired_capacity     = local.default_size.desired_capacity

  vpc_zone_identifier = var.app_private_subnet_ids

  target_group_arns = [var.app_target_group_arn]
  # depends_on = [aws_lb_target_group.app_tg] TODO

  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = "$Latest"
  }
}
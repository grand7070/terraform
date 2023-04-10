resource "aws_launch_template" "launch_template" {
  name   = "launch_template"

  image_id      = "ami-07436a5dd052caf02"

  instance_type = "t2.micro"

  key_name = "ecs_key"

  security_group_name = [
    aws_security_group.app_sg.name # ?
  ]

  block_device_mappings {
  device_name = "/dev/xvda"

    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name} >> /etc/ecs/ecs.config;
              EOF
  )
}
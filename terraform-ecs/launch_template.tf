data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_launch_template" "launch_template" {
  name   = "launch_template"

  image_id      = data.aws_ami.ecs_ami.id # ? # "ami-05848aefad8e593cf" # "ami-07436a5dd052caf02" # 지역에 맞는 ECS-optimized AMI ID

  instance_type = "t3.small"

	key_name = "ecs-key"

	vpc_security_group_ids = [
    aws_security_group.app_sg.id
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
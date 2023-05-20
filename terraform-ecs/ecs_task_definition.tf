resource "aws_cloudwatch_log_group" "ecs_cloudwatch" {
  name = "/ecs/ecs_task_defnition"
}

resource "aws_ecs_task_definition" "ecs_task_defnition" {
  family = "ecs_task_defnition"

  container_definitions = jsonencode([
    {
      name      = "app_container"
      image = "nginx:latest"
      # image     = "${aws_ecr_repository.ecr_repository.repository_url}:latest" # version...
      essential = true
      portMappings = [
        {
					# name = "app_container-8080-tcp"
          # containerPort = 8080
         containerPort = 80
					# protocol = "TCP" # default
					# appProtocol = "HTTP" # default
        }
      ]
     # entryPoint = ["java","-jar","-DSpring.profiles.active=prod","/app.jar"]


      logConfiguration = {
	      logDriver = "awslogs"
	      options = {
	        # "awslogs-group" = aws_cloudwatch_log_group.example.name
	        # "awslogs-region" = data.aws_region.current.name
	        "awslogs-group" = aws_cloudwatch_log_group.ecs_cloudwatch.name
	        "awslogs-region" = "ap-northeast-2"
	        "awslogs-stream-prefix" = "ecs"
                   #"awslogs-create-group" = "true"
                  }
      }
    }
  ])

	requires_compatibilities = ["EC2"]
      cpu       = 512 # 0.5 vCPU
      memory    = 762 # 0.8 GB
	task_role_arn         = aws_iam_role.ecs_task_role.arn
  execution_role_arn    = aws_iam_role.ecs_task_execution_role.arn
  network_mode = "bridge"
}
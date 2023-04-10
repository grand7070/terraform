resource "aws_cloudwatch_log_group" "example" {
  name = "/ecs/application"
}

resource "aws_ecs_task_definition" "ecs_task_defnition" {
  family = "ecs-task-defnition"
  requires_compatibilities = ["EC2"]
  execution_role_arn    = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn         = aws_iam_role.ecs_task_execution_role.arn # aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([
    {
      name      = "app-container"
      image     = aws_ecr_repository.ecr_repository.repository_url
      cpu       = 10
      memory    = 512
      essential = true
      entryPoint = ["java","-jar", "-DSpring.profiles.active=prod","/app.jar"]
      portMappings = [
        {
          hostPort      = 80
          containerPort = 8080
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group" = aws_cloudwatch_log_group.example.name
          "awslogs-region" = "ap-northeast-2" # data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
          "awslogs-create-group" = "true" # ?
        }
      }
    }
  ])
}
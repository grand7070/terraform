resource "aws_ecs_service" "ecs_service" {
  launch_type     = "EC2"
  task_definition = aws_ecs_task_definition.ecs_task_defnition.arn
  cluster         = aws_ecs_cluster.ecs_cluster.id
  name            = "ecs-service"
  scheduling_strategy = "REPLICA"
  desired_count   = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent = 200
  deployment_circuit_breaker {
    enable = true
    rollback = true
  }
  deployment_controller {
    type = "ECS"
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  health_check_grace_period_seconds = 300

  load_balancer {
    target_group_arn = aws_lb_target_group.exlb_app_tg.arn
    container_name   = "app-container"
    container_port   = 8080
  }
}
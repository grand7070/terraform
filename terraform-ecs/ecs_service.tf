resource "aws_ecs_service" "ecs_service" {
  cluster         = aws_ecs_cluster.ecs_cluster.id
  launch_type     = "EC2"

  task_definition = aws_ecs_task_definition.ecs_task_defnition.arn
  name            = "ecs_service"
	scheduling_strategy = "REPLICA"
  desired_count   = 1
	deployment_controller {
		type = "ECS"
	}
	deployment_minimum_healthy_percent = 100
	deployment_maximum_percent = 200
	deployment_circuit_breaker {
		enable = true
		rollback = true
	}

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "app_container" # aws_ecs_task_definition.ecs_task_defnition
    container_port   = 80 # ?
  }
	health_check_grace_period_seconds = 400

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

	# ?
#	network_configuration {
   # subnets          = [
#			aws_subnet.app_prv_a.id,
#			aws_subnet.app_prv_c.id
#		]
#		assign_public_ip = false
    #security_groups = [
   #   aws_security_group.app_sg.id
   # ]
  #}
}
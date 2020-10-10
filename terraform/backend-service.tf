resource "aws_ecs_service" "backend" {
  name            = "backend"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.nginx.arn
  launch_type     = "FARGATE"

  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = var.deployment_min_healthy_percent
  deployment_maximum_percent         = var.deployment_max_percent

  network_configuration {
    security_groups  = [aws_security_group.allow_http.id]
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs-target-group.arn
    container_name   = "nginx"
    container_port   = 80
  }

  depends_on = [
    aws_alb_listener.alb-listener
  ]

  lifecycle {
    create_before_destroy = true
  }
}
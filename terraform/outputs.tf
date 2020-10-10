output "ecs_backend_name" {
  value = aws_ecs_service.backend.name
}

output "lb_backend_dns" {
  value = aws_alb.ecs-load-balancer.dns_name
}

output "ecr_backend_uri" {
  value = aws_ecr_repository.backend.repository_url
}

output "backend_task_definition_arn" {
  value = aws_ecs_task_definition.backend_api.arn
}

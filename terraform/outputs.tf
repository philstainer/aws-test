output "name" {
  value = aws_ecs_service.test-ecs-service.name
}

output "lb_dns_name" {
  value = aws_alb.ecs-load-balancer.dns_name
}

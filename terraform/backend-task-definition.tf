data "aws_ecs_task_definition" "nginx" {
  task_definition = aws_ecs_task_definition.nginx.family
  depends_on      = [aws_ecs_task_definition.nginx]
}

resource "aws_ecs_task_definition" "nginx" {
  family                   = "hello_world"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions    = file("./backend.json")

  lifecycle {
    create_before_destroy = true
  }
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.nginx.arn
}

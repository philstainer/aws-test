resource "aws_ecs_task_definition" "backend" {
  family = "backend"

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn

  container_definitions = <<DEFINITION
  [
    {
      "name": "backend",
      "image": "${aws_ecr_repository.backend.repository_url}:latest",
      "cpu": 256,
      "memory": 512,
      "networkMode": "awsvpc",
      "portMappings": [
        {
          "containerPort": 4000,
          "hostPort": 4000
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/fargate/service/backend",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
  DEFINITION

  lifecycle {
    create_before_destroy = true
  }
}

# Policy
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

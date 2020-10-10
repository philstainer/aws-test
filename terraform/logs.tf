resource "aws_cloudwatch_log_group" "logs" {
  name              = "/fargate/service/backend"
  retention_in_days = 90

  tags = {
    Environment = "production"
    Application = "backend"
  }
}

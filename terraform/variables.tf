variable "aws_access_key" {
  type        = string
  description = "(required) access key"
}

variable "aws_secret_key" {
  type        = string
  description = "(required) secret key"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-2"
}

variable "ecs_cluster" {
  description = "ECS cluster name"
}

variable "desired_count" {
  default = "2"
}

variable "deployment_min_healthy_percent" {
  default = "100"
}

variable "deployment_max_percent" {
  default = "200"
}

variable "min_count" {
  default = "1"
}

variable "max_count" {
  default = "1"
}

variable "scale_up_cooldown_seconds" {
  default = "300"
}

variable "scale_down_cooldown_seconds" {
  default = "300"
}

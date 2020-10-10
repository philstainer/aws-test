resource "aws_appautoscaling_target" "backend" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.backend.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.min_count
  max_capacity       = var.max_count

  depends_on = [
    aws_ecs_service.backend,
  ]
}

resource "aws_appautoscaling_policy" "up" {
  name               = "scale-up"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.backend.resource_id
  scalable_dimension = aws_appautoscaling_target.backend.scalable_dimension
  service_namespace  = aws_appautoscaling_target.backend.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.scale_up_cooldown_seconds
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [
    aws_appautoscaling_target.backend,
  ]
}

resource "aws_appautoscaling_policy" "down" {
  name               = "scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.backend.resource_id
  scalable_dimension = aws_appautoscaling_target.backend.scalable_dimension
  service_namespace  = aws_appautoscaling_target.backend.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.scale_down_cooldown_seconds
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [
    aws_appautoscaling_target.backend,
  ]
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "app_service_high_cpu" {
  alarm_name          = "alarmBackendCPUUtilizationHigh"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.backend.name
  }

  alarm_actions = [aws_appautoscaling_policy.up.arn]
}

resource "aws_cloudwatch_metric_alarm" "app_service_low_cpu" {
  alarm_name          = "alarmBackendCPUUtilizationLow"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "15"

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.backend.name
  }

  alarm_actions = [aws_appautoscaling_policy.down.arn]
}

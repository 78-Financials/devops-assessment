resource "aws_appautoscaling_target" "simple_api_to_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_simple_api_svc_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "apigw_to_memory" {
  name               = "simple-api-to-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.simple_api_to_target.resource_id
  scalable_dimension = aws_appautoscaling_target.simple_api_to_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.simple_api_to_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 80
  }
}

resource "aws_appautoscaling_policy" "apigw_to_cpu" {
  name               = "simple-api-to-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.simple_api_to_target.resource_id
  scalable_dimension = aws_appautoscaling_target.simple_api_to_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.simple_api_to_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}


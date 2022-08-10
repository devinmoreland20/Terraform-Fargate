# ------ modules/autoscaling

resource "aws_appautoscaling_target" "fargate" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${var.ecs_cluster}/${var.ecs_service}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "fargate" {
  name               = var.name
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.fargate.resource_id
  scalable_dimension = aws_appautoscaling_target.fargate.scalable_dimension
  service_namespace  = aws_appautoscaling_target.fargate.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 80
  }
}

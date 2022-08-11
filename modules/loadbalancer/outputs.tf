output "lb_target_group_arn" {
  value = aws_lb_target_group.fargate.arn
}

output "lb_endpoint" {
  value = aws_lb.fargate.dns_name
}

output "lb_arn" {
  value = aws_lb.fargate.arn
}

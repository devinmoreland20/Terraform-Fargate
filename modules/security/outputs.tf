output "fargate_sg" {
  value = aws_security_group.fargate.id
}

output "fargate_sg_default" {
  value = aws_default_security_group.fargate_default.id
}


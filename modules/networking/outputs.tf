# ----- modules/networking/outputs.tf
output "subnet" {
  value = aws_subnet.fargate_subnet.*.id
}

output "vpc_id" {
  value = aws_vpc.fargate.id
}

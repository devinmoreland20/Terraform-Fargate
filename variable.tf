# ---- root/main

variable "container_name" {
  default = "centos"
}
variable "container_image" {
  default = "114148051138.dkr.ecr.us-east-1.amazonaws.com/docker:latest"
}
variable "cluster_name" {
  default = "centos"
}
variable "capacity_provider" {
  default = "FARGATE"
}
variable "family" {
  default = "centos"
}
variable "network_mode" {
  default = "awsvpc"
}
# variable "execution_role_arn" {
#   default = "arn:aws:iam::114148051138:role/ECS-ECR"
# }
# variable "task_role_arn" {
#   default = "arn:aws:iam::114148051138:role/ECS-ECR"
# }
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "lb_name" {
  default = "fargate"
}
variable "lb_type" {
  default = "application"
}

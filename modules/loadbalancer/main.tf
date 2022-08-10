
resource "aws_lb" "fargate" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = var.lb_type
  security_groups    = [var.lb_sg, var.default_sg]

  subnets = var.subnets

  enable_deletion_protection = var.enable_deletion_protection

}

resource "aws_lb_listener" "fargate" {
  load_balancer_arn = aws_lb.fargate.arn
  port              = var.lb_listener_port
  protocol          = var.lb_listener_portocol

  default_action {
    type             = var.listener_action_type
    target_group_arn = aws_lb_target_group.fargate.arn
  }
}

resource "aws_lb_target_group" "fargate" {
  name        = var.name
  port        = var.target_group_port
  protocol    = var.tg_protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type
}

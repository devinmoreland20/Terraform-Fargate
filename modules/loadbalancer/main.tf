
resource "aws_lb" "fargate" {
  name               = var.name
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = [var.lb_sg, var.default_sg]

  subnets = var.subnets

  enable_deletion_protection = false

}

resource "aws_lb_listener" "fargate" {
  load_balancer_arn = aws_lb.fargate.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fargate.arn
  }
}

resource "aws_lb_target_group" "fargate" {
  name        = var.name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

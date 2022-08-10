# --- module/ecs/main





resource "aws_ecs_cluster" "centos" {
  name = var.cluster_name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.centos.name

  capacity_providers = [var.capacity_provider]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = var.capacity_provider
  }
}

resource "aws_ecs_task_definition" "centos" {
  family                   = var.family
  requires_compatibilities = [var.capacity_provider]
  network_mode             = var.network_mode
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      cpu       = var.cpu
      memory    = var.memory
      essential = true
      logConfiguration : {
        logDriver = "awslogs",
        options = {
          awslogs-create-group  = "true",
          awslogs-group         = "/ecs/centos2",
          awslogs-region        = "us-east-1",
          awslogs-stream-prefix = "ecs"
      } }
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.host_port
        }
      ]
    },
  ])
}
resource "aws_ecs_service" "centos" {
  name            = var.cluster_name
  cluster         = aws_ecs_cluster.centos.id
  task_definition = aws_ecs_task_definition.centos.arn
  desired_count   = var.count
  load_balancer {
    target_group_arn = var.lb_target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }


  capacity_provider_strategy {
    capacity_provider = var.capacity_provider
    weight            = 1

  }
  network_configuration {
    subnets          = var.subnets
    assign_public_ip = var.assign_public_ip
  }
}

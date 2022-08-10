# ----  main.tf 

module "ecs" {
  source              = "./modules/ecs"
  count               = 2
  cluster_name        = var.cluster_name
  capacity_provider   = var.capacity_provider
  container_name      = var.container_name
  container_image     = var.container_image
  family              = var.family
  network_mode        = var.network_mode
  execution_role_arn  = module.iam.iam_role
  task_role_arn       = module.iam.iam_role
  subnets             = module.networking.subnet
  lb_target_group_arn = module.loadbalancer.lb_target_group_arn
  cpu                 = 256
  memory              = 256
  container_port      = 80
  host_port           = 80
  assign_public_ip    = true
}
module "loadbalancer" {
  source     = "./modules/loadbalancer"
  name       = var.lb_name
  lb_type    = var.lb_type
  vpc_id     = module.networking.vpc_id
  lb_sg      = module.security.fargate_sg
  subnets    = module.networking.subnet
  default_sg = module.security.fargate_sg_default
}

module "networking" {
  source           = "./modules/networking"
  vpc_cidr         = var.vpc_cidr
  private_sn_count = 2
  public_sn_count  = 2
  public_cidrs     = [for i in range(1, 3, 1) : cidrsubnet(var.vpc_cidr, 8, i)]
}

module "security" {
  source = "./modules/security"
  vpc_id = module.networking.vpc_id

}

module "autoscaling" {
  source      = "./modules/autoscaling"
  name        = "fargate"
  ecs_cluster = var.cluster_name
  ecs_service = var.cluster_name
}

module "iam" {
  source = "./modules/iam"
}



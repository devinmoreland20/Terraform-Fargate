# ----  main.tf 

module "ecs" {
  source                                    = "./modules/ecs"
  cluster_count                             = 1
  cluster_name                              = var.cluster_name
  capacity_provider                         = var.capacity_provider
  container_name                            = var.container_name
  container_image                           = var.container_image
  family                                    = var.family
  network_mode                              = var.network_mode
  execution_role_arn                        = module.iam.iam_role
  task_role_arn                             = module.iam.iam_role
  subnets                                   = module.networking.subnet
  lb_target_group_arn                       = module.loadbalancer.lb_target_group_arn
  cpu                                       = 256
  memory                                    = 512
  container_port                            = 80
  host_port                                 = 80
  assign_public_ip                          = true
  default_capacity_provider_strategy_base   = 1
  default_capacity_provider_strategy_weight = 100
  container_definitions_essential           = true


}
module "loadbalancer" {
  source                     = "./modules/loadbalancer"
  name                       = var.lb_name
  internal                   = false
  lb_type                    = var.lb_type
  vpc_id                     = module.networking.vpc_id
  lb_sg                      = module.security.fargate_sg
  subnets                    = module.networking.subnet
  default_sg                 = module.security.fargate_sg_default
  lb_listener_port           = 80
  lb_listener_portocol       = "HTTP"
  listener_action_type       = "forward"
  target_group_port          = 80
  tg_protocol                = "HTTP"
  target_type                = "ip"
  enable_deletion_protection = false
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
  source                 = "./modules/autoscaling"
  name                   = var.asg_name
  max_capacity           = 4
  min_capacity           = 1
  resource_id            = "service/${var.cluster_name}/${var.cluster_name}"
  scalable_dimension     = var.scalable_dimension
  service_namespace      = var.service_namespace
  ecs_cluster            = var.cluster_name
  ecs_service            = var.cluster_name
  policy_type            = var.policy_type
  predefined_metric_type = var.predefined_metric_type
  target_value           = 80
}

module "iam" {
  source                 = "./modules/iam"
  name                   = var.policy_name
  policy_name            = var.policy_name
  path                   = "/"
  iam_policy_description = var.iam_policy_description
  iam_policy             = file("./fargate-policy.json")
  assume_role_policy     = file("./fargate-trusted-identity.json")

}
module "web_application_firewall" {
  source                     = "./modules/waf"
  name                       = var.waf_name
  description                = "waf"
  scope                      = "REGIONAL"
  rule_name                  = "fargate"
  mng_rule_grp_state         = "AWSManagedRulesCommonRuleSet"
  vendor_name                = "AWS"
  lb_arn                     = module.loadbalancer.lb_arn
  cloudwatch_metrics_enabled = true
  vis_config_metric_name     = "friendly-rule-metric-name"
  sampled_requests_enabled   = true

}


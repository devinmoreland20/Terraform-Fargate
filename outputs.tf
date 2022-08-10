# ---- root/outputs

output "ALB_Endpoint" {
  value = module.loadbalancer.lb_endpoint
}

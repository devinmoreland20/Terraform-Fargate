resource "aws_wafv2_web_acl" "example" {
  name        = var.name
  description = var.description
  scope       = var.scope

  default_action {
    allow {}
  }
  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
    metric_name                = var.vis_config_metric_name
    sampled_requests_enabled   = var.sampled_requests_enabled
  }

  rule {
    name     = var.rule_name
    priority = 1

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = var.mng_rule_grp_state
        vendor_name = var.vendor_name
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
      metric_name                = var.vis_config_metric_name
      sampled_requests_enabled   = var.sampled_requests_enabled
    }
  }
}

resource "aws_wafv2_web_acl_association" "example" {
  resource_arn = var.lb_arn
  web_acl_arn  = aws_wafv2_web_acl.example.arn
}

locals {
  name_prefix = "${var.environment}-squid"
  
  cluster_name     = "${local.name_prefix}-cluster"
  task_family_name = "${local.name_prefix}-task"
  service_name     = "${local.name_prefix}-service"

  common_tags = {
    Environment = var.environment
    Service     = "squid-proxy"
    Terraform   = "true"
  }
}
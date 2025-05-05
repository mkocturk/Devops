# locals.tf
locals {
  project_name = "web-app"
  environment  = "production"

  common_tags = [
    "project:${local.project_name}",
    "env:${local.environment}",
    "managed-by:terraform",
    "owner:devops-team",
    "cost-center:${local.project_name}-${local.environment}"
  ]

  monitoring_tags = [
    "monitoring:enabled",
    "alerts:enabled"
  ]

  # Firewall rule defaults
  default_allowed_ports = {
    http  = 80
    https = 443
    ssh   = 22
  }

  # Naming convention for resources
  resource_prefix = "${local.project_name}-${local.environment}"
}


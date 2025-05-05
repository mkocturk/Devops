terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "digitalocean" {
  token = var.do_token
}

module "web_server" {
  source     = "./modules/droplet"
  image      = "ubuntu-22-04-x64"
  name       = "${local.resource_prefix}-${var.droplet_name}"
  region     = var.droplet_region
  size       = var.droplet_size
  ssh_keys   = var.ssh_keys
  tags       = concat(["web", "managed-by-terraform"], local.common_tags, local.monitoring_tags, var.additional_tags)
}

resource "digitalocean_firewall" "web" {
  name = "${local.resource_prefix}-firewall"
  tags = local.common_tags
  droplet_ids = [module.web_server.id]

  lifecycle {
    create_before_destroy = true
  }
}
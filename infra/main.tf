terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.24.0"
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
  ssh_keys   = [var.ssh_key_fingerprint]
  monitoring = var.enable_monitoring
  tags       = concat(["web"], local.common_tags, var.additional_tags)
  user_data  = file("${path.module}/scripts/user_data.sh")
}

# Create a firewall for securing the Droplet
resource "digitalocean_firewall" "web" {
  name = "${local.resource_prefix}-firewall"

  # Allow SSH from specified IPs
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.firewall_allowed_ips
  }

  # Allow HTTP/HTTPS from anywhere
  dynamic "inbound_rule" {
    for_each = var.http_ports
    content {
      protocol         = "tcp"
      port_range       = tostring(inbound_rule.value)
      source_addresses = ["0.0.0.0/0", "::/0"]
    }
  }
  
  # Allow outbound traffic
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Apply to Droplet using the module's ID
  droplet_ids = [module.web_server.id]
}
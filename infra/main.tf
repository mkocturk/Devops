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

# Create a Droplet for the web server
resource "digitalocean_droplet" "web" {
  image      = "ubuntu-22-04-x64"
  name       = "${local.resource_prefix}-${var.droplet_name}"
  region     = var.droplet_region
  size       = var.droplet_size
  ssh_keys   = [var.ssh_key_fingerprint]
  backups    = var.enable_backups
  monitoring = var.enable_monitoring
  tags       = concat(["web"], local.common_tags, var.additional_tags)

    user_data = <<-EOF
    #!/bin/bash
    set -e
    
    exec > >(tee -a /var/log/user-data.log) 2>&1
    echo "Starting server provisioning at $(date)"
    
    wait_for_apt() {
      while fuser /var/lib/apt/lists/lock >/dev/null 2>&1 || fuser /var/lib/dpkg/lock >/dev/null 2>&1 || fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
        echo "Waiting for apt locks..."
        sleep 5
      done
    }
    
    echo "Updating system packages..."
    wait_for_apt
    apt-get update -y
    apt-get upgrade -y
    
    echo "Applying security hardening..."
    sed -i 's/PermitRootLogin yes/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    systemctl restart sshd
    
    echo "Setting up swap space..."
    if [ ! -f /swapfile ]; then
      fallocate -l 1G /swapfile
      chmod 600 /swapfile
      mkswap /swapfile
      swapon /swapfile
      echo '/swapfile none swap sw 0 0' >> /etc/fstab
    fi
    
    echo "Configuring firewall..."
    ufw allow 22/tcp
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw --force enable
    
    echo "Server provisioning completed at $(date)"
  EOF
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

  # Allow HTTP
  dynamic "inbound_rule" {
    for_each = var.http_ports
    content {
      protocol         = "tcp"
      port_range       = inbound_rule.value
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

  # Apply to Droplets with tag "web"
  droplet_ids = [digitalocean_droplet.web.id]
}

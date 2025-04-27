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

  # Enhanced user_data for better initialization including Docker installation
  user_data = <<-EOF
    #!/bin/bash
    # System updates
    apt-get update
    apt-get upgrade -y
    apt-get install -y fail2ban ufw nginx ca-certificates curl gnupg

    # Install Docker
    # Add Docker's official GPG key
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg

    # Add the Docker repository
    echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine, containerd, and Docker Compose
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Verify Docker is installed correctly
    docker --version
    docker-compose --version

    # Add current user to docker group (not needed for root but good practice)
    usermod -aG docker $(whoami)

    # Configure UFW
    ufw allow 22/tcp
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw allow 8080/tcp
    ufw --force enable

    # Setup web server
    systemctl enable nginx
    systemctl start nginx

    # Basic security hardening
    sed -i 's/PermitRootLogin yes/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    systemctl restart sshd

    # Setup swap
    fallocate -l 1G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
    
    # Create a test Docker container to verify everything works
    docker run --name hello-world -d -p 8080:80 nginx:latest
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

  # Allow Docker test container port (8080)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "8080"
    source_addresses = ["0.0.0.0/0", "::/0"]
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

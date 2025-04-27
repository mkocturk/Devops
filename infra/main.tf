terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "web" {
  image    = "ubuntu-22-04-x64"
  name     = var.droplet_name
  region   = var.droplet_region
  size     = var.droplet_size
  ssh_keys = [var.ssh_key_fingerprint]

  tags = ["web"]

  # Ubuntu 22.04 LTS kullanıyoruz
  # Initial setup için basit bir cloud-init script
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get upgrade -y
              EOF
}

# Output tanımlamaları
output "droplet_ip" {
  value = digitalocean_droplet.web.ipv4_address
}

output "droplet_status" {
  value = digitalocean_droplet.web.status
}
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"  # Bu satır modül için gerekli
      version = "~> 2.0"
    }
  }
}
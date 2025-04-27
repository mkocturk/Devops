resource "digitalocean_droplet" "this" {
  image      = var.image
  name       = var.name
  region     = var.region
  size       = var.size
  ssh_keys   = var.ssh_keys
  backups    = var.backups
  monitoring = var.monitoring
  tags       = var.tags
  user_data  = var.user_data
}

resource "digitalocean_volume" "this" {
  count                   = var.attach_volume ? 1 : 0
  region                  = var.region
  name                    = "${var.name}-data-volume"
  size                    = var.volume_size
  description             = "Data volume for ${var.name}"
  initial_filesystem_type = "ext4"
  tags                    = var.tags
}

resource "digitalocean_volume_attachment" "this" {
  count      = var.attach_volume ? 1 : 0
  droplet_id = digitalocean_droplet.this.id
  volume_id  = digitalocean_volume.this[0].id
}


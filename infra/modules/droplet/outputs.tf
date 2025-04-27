output "id" {
  description = "The ID of the Droplet"
  value       = digitalocean_droplet.this.id
}

output "ipv4_address" {
  description = "The IPv4 address of the Droplet"
  value       = digitalocean_droplet.this.ipv4_address
}
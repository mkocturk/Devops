# outputs.tf
output "droplet_ip" {
  description = "Public IPv4 address of the DigitalOcean Droplet"
  value       = digitalocean_droplet.web.ipv4_address
}

output "droplet_status" {
  description = "Current status of the DigitalOcean Droplet"
  value       = digitalocean_droplet.web.status
}

output "droplet_name" {
  description = "Name of the DigitalOcean Droplet"
  value       = digitalocean_droplet.web.name
}
output "firewall_id" {
  description = "ID of the DigitalOcean Firewall"
  value       = digitalocean_firewall.web.id
}

output "ssh_command" {
  description = "SSH command to connect to the Droplet"
  value       = "Use: ssh -i ~/.ssh/digitalocean_devops_ssh_key root@${digitalocean_droplet.web.ipv4_address}"
}


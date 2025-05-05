# outputs.tf
output "droplet_ip" {
  description = "Public IPv4 address of the DigitalOcean Droplet"
  value       = module.web_server.ipv4_address
}

output "droplet_id" {
  description = "ID of the DigitalOcean Droplet"
  value       = module.web_server.id
}

output "droplet_name" {
  description = "Name of the DigitalOcean Droplet"
  value       = "${local.resource_prefix}-${var.droplet_name}"
}

output "firewall_id" {
  description = "ID of the DigitalOcean Firewall"
  value       = digitalocean_firewall.web.id
}

output "ssh_command" {
  description = "SSH command to connect to the Droplet"
  value       = "Use: ssh -i ~/.ssh/digitalocean_devops_ssh_key root@${module.web_server.ipv4_address}"
}
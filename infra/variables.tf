variable "do_token" {
  description = "DigitalOcean API Token"
  type        = string
  sensitive   = true
}

variable "droplet_name" {
  description = "Name of the Droplet"
  type        = string
  default     = "web-server"
}

variable "droplet_region" {
  description = "Region for the Droplet"
  type        = string
  default     = "fra1"  # Frankfurt 1
}

variable "droplet_size" {
  description = "Size of the Droplet"
  type        = string
  default     = "s-1vcpu-1gb"  # 1GB RAM, 1 vCPU
}

variable "ssh_key_fingerprint" {
  description = "SSH key fingerprint for Droplet access"
  type        = string
}
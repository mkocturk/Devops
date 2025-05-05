variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "ssh_fingerprint" {
  description = "SSH key fingerprint"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private SSH key"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "fra1"  # Frankfurt 1
}

variable "droplet_image" {
  description = "Droplet image"
  type        = string
  default     = "ubuntu-20-04-x64"
}

variable "droplet_name" {
  description = "Name of the droplet"
  type        = string
  default     = "vpn-server"
}

variable "droplet_size" {
  description = "Droplet size"
  type        = string
  default     = "s-1vcpu-1gb"
}
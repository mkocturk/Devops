variable "do_token" {
  description = "DigitalOcean API Token for authentication"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.do_token) > 32
    error_message = "The DigitalOcean API token must be valid and complete."
  }
}

variable "droplet_name" {
  description = "Name of the DigitalOcean Droplet (web server instance)"
  type        = string
  default     = "web-server"

  validation {
    condition     = length(var.droplet_name) >= 3 && length(var.droplet_name) <= 63
    error_message = "Droplet name must be between 3 and 63 characters."
  }
}

variable "droplet_region" {
  description = "DigitalOcean region where the Droplet will be created"
  type        = string
  default     = "fra1" # Frankfurt 1

  validation {
    condition     = contains(["fra1", "nyc1", "nyc3", "ams3", "sfo3", "sgp1", "lon1"], var.droplet_region)
    error_message = "The region must be a valid DigitalOcean region slug."
  }
}

variable "droplet_size" {
  description = "Size/plan of the DigitalOcean Droplet"
  type        = string
  default     = "s-1vcpu-1gb" # 1GB RAM, 1 vCPU

  validation {
    condition     = can(regex("^(s|c)-", var.droplet_size))
    error_message = "The Droplet size must be a valid DigitalOcean size slug."
  }
}

variable "ssh_key_fingerprint" {
  description = "SSH key fingerprint for secure Droplet access"
  type        = string

  validation {
    condition     = length(var.ssh_key_fingerprint) > 0
    error_message = "SSH key fingerprint must be provided for secure access to the Droplet."
  }
}

variable "enable_backups" {
  description = "Enable or disable automated backups for the Droplet"
  type        = bool
  default     = false
}

variable "enable_monitoring" {
  description = "Enable or disable DigitalOcean monitoring for the Droplet"
  type        = bool
  default     = true
}

variable "firewall_allowed_ips" {
  description = "List of IP addresses allowed to access the Droplet via SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Allow from anywhere - consider restricting in production
}

variable "http_ports" {
  description = "List of HTTP ports to be opened in the firewall"
  type        = list(number)
  default     = [80, 443]
}

variable "additional_tags" {
  description = "Additional tags to apply to resources"
  type        = list(string)
  default     = []
}

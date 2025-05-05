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
  description = "The size of the Droplet"
  type        = string
  validation {
    condition     = can(regex("^(s|c)-", var.droplet_size))
    error_message = "Droplet size must start with 's-' or 'c-' prefix."
  }
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

variable "allowed_http_ips" {
  description = "List of IP addresses allowed to access HTTP/HTTPS ports"
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
}

variable "slack_webhook_url" {
  description = "Slack webhook URL for monitoring alerts"
  type        = string
  sensitive   = true
  default     = ""  # Empty default, should be provided in terraform.tfvars
}

variable "ssh_keys" {
  description = "List of SSH key IDs or fingerprints to add to the Droplet"
  type        = list(string)
}
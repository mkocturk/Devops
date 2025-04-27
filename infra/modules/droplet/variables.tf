variable "image" {
  description = "The Droplet image ID or slug"
  type        = string
}

variable "name" {
  description = "The Droplet name"
  type        = string
}

variable "region" {
  description = "The region to start the Droplet in"
  type        = string
}

variable "size" {
  description = "The instance size to start"
  type        = string
}

variable "ssh_keys" {
  description = "A list of SSH key fingerprints"
  type        = list(string)
}

variable "monitoring" {
  description = "Whether to enable monitoring"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A list of tags to apply to the Droplet"
  type        = list(string)
  default     = []
}

variable "user_data" {
  description = "User data for the Droplet"
  type        = string
  default     = ""
}
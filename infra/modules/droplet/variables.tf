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

variable "backups" {
  description = "Whether to enable backups"
  type        = bool
  default     = false
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

variable "attach_volume" {
  description = "Whether to attach a volume to the Droplet"
  type        = bool
  default     = false
}

variable "volume_size" {
  description = "The size of the volume in GB"
  type        = number
  default     = 10
}


variable "default_tags_enabled" {
  description = "Option to enable or disable default tags."
  type        = bool
  default     = true
}

variable "nic_extra_tags" {
  description = "Extra tags to set on the network interface."
  type        = map(string)
  default     = {}
}

variable "public_ip_extra_tags" {
  description = "Extra tags to set on the public IP resource."
  type        = map(string)
  default     = {}
}

variable "extra_tags" {
  description = "Extra tags to set on each created resource."
  type        = map(string)
  default     = {}
}

variable "os_disk_extra_tags" {
  description = "Extra tags to set on the OS disk."
  type        = map(string)
  default     = {}
}

variable "os_disk_tagging_enabled" {
  description = "Should OS disk tagging be enabled? Defaults to `true`."
  type        = bool
  default     = true
}

variable "extensions_extra_tags" {
  description = "Extra tags to set on the VM extensions."
  type        = map(string)
  default     = {}
}

variable "os_disk_overwrite_tags" {
  description = "True to overwrite existing OS disk tags instead of merging."
  type        = bool
  default     = false
}

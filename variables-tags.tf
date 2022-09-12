variable "default_tags_enabled" {
  description = "Option to enable or disable default tags."
  type        = bool
  default     = true
}

variable "extra_tags" {
  description = "Extra tags to set on each created resource."
  type        = map(string)
  default     = {}
}

variable "nic_extra_tags" {
  description = "Extra tags to set on the network interface."
  type        = map(string)
  default     = {}
}

variable "os_disk_extra_tags" {
  description = "Extra tags to set on the OS disk."
  type        = map(string)
  default     = {}
}

variable "public_ip_extra_tags" {
  description = "Extra tags to set on the Public IP."
  type        = map(string)
  default     = {}
}

variable "extensions_extra_tags" {
  description = "Extra tags to set on the VM extensions."
  type        = map(string)
  default     = {}
}

# Generic naming variables
variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name"
  type        = string
  default     = ""
}

variable "use_caf_naming" {
  description = "Use the Azure CAF naming provider to generate default resource name. `custom_name` override this if set. Legacy default name is used if this is set to `false`."
  type        = bool
  default     = true
}

# Custom naming override
variable "custom_name" {
  description = "Custom name for the Virtual Machine. Generated if not set."
  type        = string
  default     = ""
}

variable "custom_public_ip_name" {
  description = "Custom name for public IP. Generated if not set."
  type        = string
  default     = null
}

variable "custom_nic_name" {
  description = "Custom name for the NIC interface. Generated if not set."
  type        = string
  default     = null
}

variable "custom_ipconfig_name" {
  description = "Custom name for the IP config of the NIC. Generated if not set."
  type        = string
  default     = null
}

variable "os_disk_custom_name" {
  description = "Custom name for OS disk. Generated if not set."
  type        = string
  default     = null
}

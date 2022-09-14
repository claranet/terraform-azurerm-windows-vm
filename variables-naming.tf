# Generic naming variables
variable "name_prefix" {
  description = "Optional prefix for the generated name."
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name."
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

variable "custom_computer_name" {
  description = "Custom name for the Virtual Machine Hostname. Based on `custom_name` if not set."
  type        = string
  default     = ""

  validation {
    condition     = var.custom_computer_name == "" || (can(regex("^[a-zA-Z0-9-]{1,15}$", var.custom_computer_name)) && !can(regex("^[0-9-]", var.custom_computer_name)))
    error_message = "The `custom_computer_name` value must be 15 characters long at most and can contain only allowed characters (Windows constraint) `[a-zA-Z0-9-]{1,15}`."
  }
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

variable "custom_dcr_name" {
  description = "Custom name for Data collection rule association"
  type        = string
  default     = null
}

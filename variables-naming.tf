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

# Custom naming override
variable "custom_name" {
  description = "Custom name for the Virtual Machine. Generated if not set."
  type        = string
  default     = ""
}

variable "computer_name" {
  description = "Custom name for the Virtual Machine hostname. Based on `var.custom_name` if not set."
  type        = string
  default     = ""

  validation {
    condition     = var.computer_name == "" || (can(regex("^[a-zA-Z0-9-]{1,15}$", var.computer_name)) && !can(regex("^[0-9-]", var.computer_name)))
    error_message = "The value of `var.computer_name` must be 15 characters long at most and can only contain allowed characters (Windows constraint): `[a-zA-Z0-9-]{1,15}`."
  }
}

variable "public_ip_custom_name" {
  description = "Custom name for the Public IP. Generated if not set."
  type        = string
  default     = null
}

variable "nic_custom_name" {
  description = "Custom name for the network interface. Generated if not set."
  type        = string
  default     = null
}

variable "ip_configuration_custom_name" {
  description = "Custom name for the IP configuration of the network interface. Generated if not set."
  type        = string
  default     = null
}

variable "os_disk_custom_name" {
  description = "Custom name for the OS disk. Generated if not set."
  type        = string
  default     = null
}

variable "dcr_custom_name" {
  description = "Custom name for the Data Collection Rule association."
  type        = string
  default     = null
}

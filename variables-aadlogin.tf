variable "aad_login_enabled" {
  description = "Enable login against Azure Active Directory."
  type        = bool
  default     = false
}

variable "aad_login_extension_version" {
  description = "VM Extension version for Azure Active Directory Login extension."
  type        = string
  default     = "1.0"
}

variable "aad_login_user_objects_ids" {
  description = "Active Directory objects IDs to allow to connect as a standard user on Windows VM."
  type        = list(string)
  default     = []
}

variable "aad_login_admin_objects_ids" {
  description = "Active Directory objects IDs to allow to connect as an admin user on Windows VM."
  type        = list(string)
  default     = []
}

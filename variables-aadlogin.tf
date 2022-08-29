variable "aad_login_enabled" {
  description = "Enable login against Azure Active Directory"
  type        = bool
  default     = false
}

variable "aad_login_extension_version" {
  description = "VM Extension version for Azure Active Directory Login extension"
  type        = string
  default     = "1.0"
}

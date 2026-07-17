variable "azure_region" {
  description = "Azure region to use."
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming."
  type        = string
}

variable "environment" {
  description = "Project environment."
  type        = string
}

variable "stack" {
  description = "Project stack name."
  type        = string
}

variable "vm_administrator_login" {
  description = "Administrator login for the Virtual Machine."
  type        = string
}

variable "vm_administrator_password" {
  description = "Administrator password for the Virtual Machine."
  type        = string
  sensitive   = true
}

variable "key_vault_certificate_names" {
  description = "List of Key Vault certificate names to install in the Virtual Machine."
  type        = list(string)
  default     = []
}

variable "key_vault_admin_objects_ids" {
  description = "List of admin IDs for the Key Vault."
  type        = list(string)
}

variable "certificate" {
  description = "VM TLS certificate."
  type        = string
}

variable "private_key" {
  description = "VM TLS certificate private_key."
  type        = string
}

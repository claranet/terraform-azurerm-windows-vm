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

variable "vm_admin_login" {
  description = "Administrator login for the Virtual Machine."
  type        = string
}

variable "vm_admin_password" {
  description = "Administrator password for the Virtual Machine."
  type        = string
}

variable "vm_admin_ip_addresses" {
  description = "List of IP addresses allowed to connect via WinRM to the Windows Virtual Machine."
  type        = list(string)
}

variable "key_vault_admin_objects_ids" {
  description = "List of admin IDs for the Key Vault."
  type        = list(string)
}

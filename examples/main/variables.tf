variable "azure_region" {
  description = "Azure region to use."
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "stack" {
  description = "Project stack name"
  type        = string
}

variable "vm_administrator_login" {
  description = "Administrator login for Virtual Machine"
  type        = string
}

variable "vm_administrator_password" {
  description = "Administrator password for Virtual Machine"
  type        = string
}

variable "keyvault_admin_objects_ids" {
  description = "List of Admin IDs of the KeyVault"
  type        = list(string)
}

variable "admin_ip_addresses" {
  description = "IPs adresses to authorize to connect with WinRM"
  type        = string
}

variable "location" {
  description = "Azure location."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
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

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "key_vault_id" {
  description = "Id of the Azure Key Vault to use for VM certificate"
  type        = string
}

variable "subnet_id" {
  description = "Id of the Subnet in which create the Virtual Machine"
  type        = string
}

variable "admin_username" {
  description = "Username for Virtual Machine administrator account"
  type        = string
}

variable "admin_password" {
  description = "Password for Virtual Machine administrator account"
  type        = string
}

variable "vm_size" {
  description = "Size (SKU) of the Virtual Machin to create."
  type        = string
}

variable "custom_name" {
  description = "Custom name for the Virtual Machine. Should be suffixed by \"-vm\". Generated if not set."
  type        = string
  default     = ""
}

variable "availability_set_id" {
  description = "Id of the availability set in which host the Virtual Machine."
  type        = string
}

variable "diagnostics_storage_account_name" {
  description = "Name of the Storage Account in which store vm diagnostics"
  type        = string
}

variable "diagnostics_storage_account_key" {
  description = "Access key of the Storage Account in which store vm diagnostics"
  type        = string
}

variable "vm_image" {
  description = "Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#storage_image_reference"
  type        = map(string)

  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

variable "delete_os_disk_on_termination" {
  description = "Should the OS Disk (either the Managed Disk / VHD Blob) be deleted when the Virtual Machine is destroyed?"
  type        = string
  default     = "false"
}

variable "delete_data_disks_on_termination" {
  description = "Should the Data Disks (either the Managed Disks / VHD Blobs) be deleted when the Virtual Machine is destroyed?"
  type        = string
  default     = "false"
}

variable "extra_tags" {
  description = "Extra tags to set on each created resource."
  type        = map(string)
  default     = {}
}

variable "certificate_validity_in_months" {
  description = "The created certificate validity in months"
  type        = string
  default     = "48"
}

variable "custom_dns_label" {
  description = "The DNS label to use for public access. VM name if not set. DNS will be <label>.westeurope.cloudapp.azure.com"
  type        = string
  default     = ""
}

variable "public_ip_sku" {
  description = "Sku for the public IP attached to the VM. Can be `null` if no public IP needed."
  type        = string
  default     = "Standard"
}

variable "attach_load_balancer" {
  description = "True to attach this VM to a Load Balancer"
  type        = bool
  default     = false
}

variable "load_balancer_backend_pool_id" {
  description = "Id of the Load Balancer Backend Pool to attach the VM."
  type        = string
  default     = null
}

variable "attach_application_gateway" {
  description = "True to attach this VM to an Application Gateway"
  type        = bool
  default     = false
}

variable "application_gateway_backend_pool_id" {
  description = "Id of the Application Gateway Backend Pool to attach the VM."
  type        = string
  default     = null
}

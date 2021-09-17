variable "location" {
  description = "Azure location."
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

variable "key_vault_certificates_names" {
  description = "List of Azure Key Vault certificates names to install in the VM"
  type        = list(string)
  default     = null
}

variable "key_vault_certificates_polling_rate" {
  description = "Polling rate (in seconds) for Key Vault certificates retrieval"
  type        = number
  default     = 300
}

variable "key_vault_certificates_store_name" {
  description = "Name of the cetrificate store on which install the Key Vault certificates"
  type        = string
  default     = "MY"
}

variable "subnet_id" {
  description = "Id of the Subnet in which create the Virtual Machine"
  type        = string
  default     = null
}

variable "nic_extra_tags" {
  description = "Extra tags to set on the network interface."
  type        = map(string)
  default     = {}
}

variable "nic_nsg_id" {
  description = "NSG ID to associate on the Network Interface. No association if null."
  type        = string
  default     = null
}

variable "static_private_ip" {
  description = "Static private IP. Private IP is dynamic if not set."
  type        = string
  default     = null
}

variable "nic_enable_accelerated_networking" {
  description = "Should Accelerated Networking be enabled? Defaults to `false`."
  type        = bool
  default     = false
}

variable "custom_ipconfig_name" {
  description = "Custom name for the IP config of the NIC. Should be suffixed by \"-nic-ipconfig\". Generated if not set."
  type        = string
  default     = null
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
  description = "Size (SKU) of the Virtual Machine to create."
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
  default     = null
}

variable "zone_id" {
  description = "Index of the Availability Zone which the Virtual Machine should be allocated in."
  type        = number
  default     = null
}

variable "diagnostics_storage_account_name" {
  description = "Name of the Storage Account in which store Virtual Machine boot diagnostics"
  type        = string
}

variable "vm_image" {
  description = "Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/windows_virtual_machine.html#source_image_reference"
  type        = map(string)

  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

variable "vm_image_id" {
  description = "The ID of the Image which this Virtual Machine should be created from. This variable supersedes the `vm_image` variable if not null."
  type        = string
  default     = null
}

variable "os_disk_extra_tags" {
  description = "Extra tags to set on the OS disk."
  type        = map(string)
  default     = {}
}

variable "storage_os_disk_config" {
  description = "Map to configure OS storage disk. (Caching, size, storage account type...)"
  type        = map(string)
  default     = {}
}

variable "storage_data_disk_config" {
  description = "Map of data disks to attach to the Virtual Machine. Map attributes: `storage_account_type` (optional, defaults to `Standard_LRS`), `create_option` (optional, defaults to `Empty`), `disk_size_gb`, `lun` & `caching` (optional, defaults to `ReadWrite`). See [virtual_machine_data_disk_attachment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) & [managed_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk)"
  type        = map(any)
  default     = {}
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

variable "public_ip_extra_tags" {
  description = "Extra tags to set on the Public IP."
  type        = map(string)
  default     = {}
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

variable "license_type" {
  description = "Specifies the BYOL Type for this Virtual Machine. Possible values are `Windows_Client` and `Windows_Server` if set."
  type        = string
  default     = null
}

variable "log_analytics_workspace_guid" {
  description = "GUID of the Log Analytics Workspace to link with"
  type        = string
}

variable "log_analytics_workspace_key" {
  description = "Access key of the Log Analytics Workspace to link with"
  type        = string
}

variable "backup_policy_id" {
  description = "Backup policy ID from the Recovery Vault to attach the Virtual Machine to (value to `null` to disable backup)"
  type        = string
}

variable "azure_monitor_data_collection_rule_id" {
  description = "Data Collection Rule ID from Azure Monitor for metrics and logs collection"
  type        = string
}

variable "azure_monitor_agent_version" {
  description = "Azure Monitor Agent extension version"
  type        = string
  default     = "1.1.2"
}

variable "log_analytics_agent_version" {
  description = "Azure Log Analytics extension version"
  type        = string
  default     = "1.0"
}

variable "key_vault" {
  description = "ID of the Key Vault to use for Virtual Machine certificate (value to `null` to disable WinRM certificate)."
  type = object({
    id = string
  })
}

variable "key_vault_certificates" {
  description = <<EOD
Key Vault certificates object.
```
names        = List of Key Vault certificates names to install in the Virtual Machine.
store_name   = Name of the certificate store in which to install the Key Vault certificates.
polling_rate = Polling rate (in seconds) for Key Vault certificates retrieval.
```
EOD
  type = object({
    names        = optional(list(string))
    store_name   = optional(string, "MY")
    polling_rate = optional(number, 300)
  })
  default = {}
}

variable "certificate_validity_in_months" {
  description = "The created certificate validity in months."
  type        = number
  default     = 48
}

## Network variables
variable "subnet" {
  description = "ID of the Subnet in which to create the Virtual Machine."
  type = object({
    id = string
  })
}

variable "nic_accelerated_networking_enabled" {
  description = "Should accelerated networking be enabled? Defaults to `true`."
  type        = bool
  default     = true
}

variable "static_private_ip" {
  description = "Static private IP address. Dynamic addressing if not set."
  type        = string
  default     = null
}

## Virtual Machine variables
variable "custom_data" {
  description = "The base64-encoded custom data which should be used for this Virtual Machine. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "user_data" {
  description = "The base64-encoded user data which should be used for this Virtual Machine."
  type        = string
  default     = null
}

variable "admin_username" {
  description = "Username for the Virtual Machine administrator account."
  type        = string
}

variable "admin_password" {
  description = "Password for the Virtual Machine administrator account."
  type        = string
}

variable "vm_size" {
  description = "Size (SKU) of the Virtual Machine to create."
  type        = string
}

variable "availability_set" {
  description = "ID of the Availability Set in which to locate the Virtual Machine."
  type = object({
    id = string
  })
  default = null
}

variable "zone_id" {
  description = "Index of the Availability Zone which the Virtual Machine should be allocated in."
  type        = number
  default     = null
}

variable "vm_image" {
  description = "Virtual Machine source image information. See [documentation](https://www.terraform.io/docs/providers/azurerm/r/windows_virtual_machine.html#source_image_reference)."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = optional(string, "latest")
  })
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }
}

variable "vm_image_id" {
  description = "ID of the source image which this Virtual Machine should be created from. This variable supersedes `var.vm_image` if not `null`."
  type        = string
  default     = null
}

variable "vm_plan" {
  description = "Virtual Machine plan image information. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#plan). This variable has to be used for BYOS image. Before using BYOS image, you need to accept legal plan terms. See [documentation](https://docs.microsoft.com/en-us/cli/azure/vm/image?view=azure-cli-latest#az_vm_image_accept_terms)."
  type = object({
    name      = string
    product   = string
    publisher = string
  })
  default = null
}

variable "storage_data_disk_config" {
  description = "Map of objects to configure storage data disk(s)."
  type = map(object({
    name                 = optional(string)
    create_option        = optional(string, "Empty")
    disk_size_gb         = number
    lun                  = optional(number)
    caching              = optional(string, "ReadWrite")
    storage_account_type = optional(string, "StandardSSD_ZRS")
    source_resource_id   = optional(string)
    extra_tags           = optional(map(string), {})
  }))
  default = {}
}

variable "custom_dns_label" {
  description = "The DNS label to use for public access. Virtual Machine name if not set. DNS label will be `<label>.westeurope.cloudapp.azure.com`."
  type        = string
  default     = ""
}

variable "public_ip_enabled" {
  description = "Should a Public IP be attached to the Virtual Machine?"
  type        = bool
  default     = false
  nullable    = false
}

variable "public_ip_zones" {
  description = "Availability Zones of the Public IP attached to the Virtual Machine. Can be `null` if no zone distpatch."
  type        = list(number)
  default     = [1, 2, 3]
}

variable "load_balancer_attachment" {
  description = "ID of the Load Balancer Backend Pool to attach the Virtual Machine to."
  type = object({
    id = string
  })
  default = null
}

variable "application_gateway_attachment" {
  description = "ID of the Application Gateway Backend Pool to attach the Virtual Machine to."
  type = object({
    id = string
  })
  default = null
}

variable "license_type" {
  description = "Specifies the BYOL type for this Virtual Machine. Possible values are `Windows_Client` and `Windows_Server`."
  type        = string
  default     = null
}

variable "os_disk_size_gb" {
  description = "Specifies the size of the OS disk in gigabytes."
  type        = string
  default     = null
}

variable "os_disk_storage_account_type" {
  description = "The type of Storage Account used to store the operating system disk. Possible values are `Standard_LRS`, `StandardSSD_LRS`, `Premium_LRS`, `StandardSSD_ZRS` and `Premium_ZRS`."
  type        = string
  default     = "Premium_ZRS"
  nullable    = false

  validation {
    condition     = contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS", "StandardSSD_ZRS", "Premium_ZRS"], var.os_disk_storage_account_type)
    error_message = "`var.os_disk_storage_account_type` must be one of `Standard_LRS`, `StandardSSD_LRS`, `Premium_LRS`, `StandardSSD_ZRS` or `Premium_ZRS`."
  }
}

variable "os_disk_caching" {
  description = "Specifies the caching requirements for the OS disk."
  type        = string
  default     = "ReadWrite"
}

variable "encryption_at_host_enabled" {
  description = "Should all disks (including the temporary disk) attached to the Virtual Machine be encrypted by enabling Encryption at Host? See [documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli#finding-supported-vm-sizes) for more information on compatible Virtual Machine sizes."
  type        = bool
  default     = true
}

variable "vm_agent_platform_updates_enabled" {
  description = "Specifies whether VMAgent Platform Updates is enabled. Defaults to `false`."
  type        = bool
  default     = false
}

variable "vtpm_enabled" {
  description = "Specifies if vTPM (virtual Trusted Platform Module) and Trusted Launch is enabled for the Virtual Machine. Defaults to `true`. Changing this forces a new resource to be created."
  type        = bool
  default     = true
}

variable "ultra_ssd_enabled" {
  description = "Specifies whether Ultra Disks is enabled (`UltraSSD_LRS` storage type for data disks)."
  type        = bool
  default     = null
}

variable "disk_controller_type" {
  description = "Specifies the Disk Controller Type used for this Virtual Machine. Possible values are `SCSI` and `NVMe`."
  type        = string
  default     = null
}

## Identity variable
variable "identity" {
  description = "Identity block. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#identity)."
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = {
    type         = "SystemAssigned"
    identity_ids = []
  }
}

## Spot Instance variables
variable "spot_instance_enabled" {
  description = "`true` to deploy the Virtual Machine as a Spot Instance."
  type        = bool
  default     = false
  nullable    = false
}

variable "spot_instance_max_bid_price" {
  description = "The maximum price you're willing to pay for this Virtual Machine in US dollars; must be greater than the current spot price. `-1` if you don't want the Virtual Machine to be evicted for price reasons."
  type        = number
  default     = -1
  nullable    = false
}

variable "spot_instance_eviction_policy" {
  description = "Specifies what should happen when the Virtual Machine is evicted for price reasons. At this time, the only supported value is `Deallocate`. Changing this forces a new resource to be created."
  type        = string
  default     = "Deallocate"
  nullable    = false
}

## Backup variable
variable "backup_policy" {
  description = "Backup policy ID from the Recovery Vault to attach the Virtual Machine to. Can be `null` to disable backup."
  type = object({
    id = string
  })
}

## Patching variables
variable "patch_mode" {
  description = "Specifies the mode of in-guest patching to this Windows Virtual Machine. Possible values are `Manual`, `AutomaticByOS` and `AutomaticByPlatform`."
  type        = string
  default     = "AutomaticByPlatform"
  nullable    = false

  validation {
    condition     = contains(["Manual", "AutomaticByOS", "AutomaticByPlatform"], var.patch_mode)
    error_message = "`var.patch_mode` must be either `Manual`, `AutomaticByOS` or `AutomaticByPlatform`."
  }
}

variable "hotpatching_enabled" {
  description = "Should the Virtual Machine be patched without requiring a reboot?"
  type        = bool
  default     = false
}

variable "maintenance_configurations_ids" {
  description = "List of maintenance configurations to attach to this Virtual Machine."
  type        = list(string)
  default     = []
}

variable "patching_reboot_setting" {
  description = "Specifies the reboot setting for platform scheduled patching. Possible values are `Always`, `IfRequired` and `Never`."
  type        = string
  default     = "IfRequired"
  nullable    = false

  validation {
    condition     = contains(["Always", "IfRequired", "Never"], var.patching_reboot_setting)
    error_message = "`var.patching_reboot_setting` must be either `Always`, `IfRequired` or `Never`."
  }
}

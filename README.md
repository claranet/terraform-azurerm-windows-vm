# Azure Windows Virtual Machine
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/windows-vm/azurerm/)

This module creates a [Windows Virtual Machine](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/) with 
[Windows Remote Management (WinRM)](https://docs.microsoft.com/en-us/windows/desktop/WinRM/portal) activated.

The Windows Virtual Machine comes with:
 * [Azure Diagnostics](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/diagnostics-extension-overview) activated and configured
 * A link to a [Log Analytics Workspace](https://docs.microsoft.com/en-us/azure/azure-monitor/overview) for [logging](https://docs.microsoft.com/en-us/azure/azure-monitor/learn/quick-collect-azurevm) and [patching](https://docs.microsoft.com/en-us/azure/automation/automation-update-management) management
 * An optional link to a [Load Balancer](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-overview) or [Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/overview)

This code is mostly based on [Tom Harvey](https://github.com/tombuildsstuff) work: https://github.com/terraform-providers/terraform-provider-azurerm/tree/master/examples/virtual-machines/provisioners/windows

Following tags are automatically set with default values: `env`, `stack`, `os_family`, `os_distribution`, `os_version`.

## Limitations

* A self-signed certificate is generated and associated

## Requirements

* Powershell CLI installed with pwsh executable available
* [Azure powershell module](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps) installed
* The port 5986 must be reachable
* An [Azure Key Vault](https://docs.microsoft.com/en-us/azure/key-vault/) configured with VM deployment enabled will be used
* An existing [Log Analytics Workspace](https://docs.microsoft.com/en-us/azure/azure-monitor/overview) is mandatory for patching ang logging management

## Version compatibility

| Module version    | Terraform version | AzureRM version |
|-------------------|-------------------|-----------------|
| >= 3.x.x          | 0.12.x            | >= 2.0          |
| >= 2.x.x, < 3.x.x | 0.12.x            | <  2.0          |
| <  2.x.x          | 0.11.x            | <  2.0          |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "azure-network-vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment      = var.environment
  location         = module.azure-region.location
  location_short   = module.azure-region.location_short
  client_name      = var.client_name
  stack            = var.stack

  resource_group_name = module.rg.resource_group_name
  vnet_cidr           = ["10.10.0.0/16"]
}

module "network-security-group" {
  source  = "claranet/nsg/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
}

module "azure-network-subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  environment         = var.environment
  location_short      = module.azure-region.location_short
  client_name         = var.client_name
  stack               = var.stack

  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = module.azure-network-vnet.virtual_network_name
  subnet_cidr_list     = ["10.10.10.0/24"]

  network_security_group_count = 1
  network_security_group_ids   = [module.network-security-group.network_security_group_id]
}

module "key_vault" {
  source  = "claranet/keyvault/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  # Mandatory for use with VM deployment
  enabled_for_deployment = "true"

  admin_objects_ids = [local.keyvault_admin_objects_ids]
}

resource "azurerm_network_security_rule" "winrm" {
  name = "Allow-winrm-rule"

  resource_group_name         = module.rg.resource_group_name
  network_security_group_name = module.network-security-group.network_security_group_name

  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "5986"
  source_address_prefixes    = [local.admin_ip_addresses]
  destination_address_prefix = "*"
}

resource "azurerm_availability_set" "vm_avset" {
  name                = "${var.stack}-${var.client_name}-${module.azure-region.location_short}-${var.environment}-as"
  location            = module.azure-region.location
  resource_group_name = module.rg.resource_group_name
  managed             = "true"
}

module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
}

module "vm" {
  source  = "claranet/windows-vm/azurerm"
  version = "x.x.x"

  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name

  key_vault_id                     = module.key_vault.key_vault_id
  subnet_id                        = module.azure-network-subnet.subnet_ids[0]
  vm_size                          = "Standard_B2s"
  custom_name                      = local.vm_name
  admin_username                   = var.vm_admin_username
  admin_password                   = var.vm_admin_password
  diagnostics_storage_account_name = data.terraform_remote_state.run_common.logs_storage_account_name
  diagnostics_storage_account_key  = data.terraform_remote_state.run.outputs.logs_storage_account_primary_access_key
  log_analytics_workspace_guid     = module.logs.log_analytics_workspace_guid
  log_analytics_workspace_key      = module.logs.log_analytics_workspace_primary_key

  availability_set_id              = azurerm_availability_set.vm_avset.id
  # or use Availability Zone
  # zone_id = 1

  vm_image = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter-with-Containers"
    version   = "latest"
  }

  # Use unmanaged disk if needed
  # If those blocks are not defined, it will use managed_disks
  storage_os_disk_config = {
    vhd_uri      = "https://${module.storage_account.name}.blob.core.windows.net/${azurerm_storage_container.disks.name}/${local.vm_name}-osdisk.vhd"
    disk_size_gb = "150" # At least 127 Gb
    os_type      = "Windows"
  }

  storage_data_disk_config = {
    0 = { # Used to define lun parameter
      vhd_uri      = "https://${module.storage_account.name}.blob.core.windows.net/${azurerm_storage_container.disks.name}/${local.vm_name}-datadisk0.vhd"
      disk_size_gb = "500"
    }
  }

}
```

## Ansible usage

The created virtual machine can be used with Ansible this way.

```bash
ansible all -i <public_ip_address>, -m win_ping -e ansible_user=<vm_username> -e ansible_password==<vm_password> -e ansible_connection=winrm -e ansible_winrm_server_cert_validation=ignore
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_password | Password for Virtual Machine administrator account | `string` | n/a | yes |
| admin\_username | Username for Virtual Machine administrator account | `string` | n/a | yes |
| application\_gateway\_backend\_pool\_id | Id of the Application Gateway Backend Pool to attach the VM. | `string` | `null` | no |
| attach\_application\_gateway | True to attach this VM to an Application Gateway | `bool` | `false` | no |
| attach\_load\_balancer | True to attach this VM to a Load Balancer | `bool` | `false` | no |
| availability\_set\_id | Id of the availability set in which host the Virtual Machine. | `string` | `null` | no |
| certificate\_validity\_in\_months | The created certificate validity in months | `string` | `"48"` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_dns\_label | The DNS label to use for public access. VM name if not set. DNS will be <label>.westeurope.cloudapp.azure.com | `string` | `""` | no |
| custom\_ipconfig\_name | Custom name for the IP config of the NIC. Should be suffixed by "-nic-ipconfig". Generated if not set. | `string` | n/a | yes |
| custom\_name | Custom name for the Virtual Machine. Should be suffixed by "-vm". Generated if not set. | `string` | `""` | no |
| delete\_data\_disks\_on\_termination | Should the Data Disks (either the Managed Disks / VHD Blobs) be deleted when the Virtual Machine is destroyed? | `string` | `"false"` | no |
| delete\_os\_disk\_on\_termination | Should the OS Disk (either the Managed Disk / VHD Blob) be deleted when the Virtual Machine is destroyed? | `string` | `"false"` | no |
| diagnostics\_storage\_account\_key | Access key of the Storage Account in which store vm diagnostics | `string` | n/a | yes |
| diagnostics\_storage\_account\_name | Name of the Storage Account in which store vm diagnostics | `string` | n/a | yes |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to set on each created resource. | `map(string)` | `{}` | no |
| key\_vault\_id | Id of the Azure Key Vault to use for VM certificate | `string` | n/a | yes |
| license\_type | Specifies the BYOL Type for this Virtual Machine. Possible values are `Windows_Client` and `Windows_Server` if set. | `string` | `null` | no |
| load\_balancer\_backend\_pool\_id | Id of the Load Balancer Backend Pool to attach the VM. | `string` | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| log\_analytics\_workspace\_guid | GUID of the Log Analytics Workspace to link with | `string` | n/a | yes |
| log\_analytics\_workspace\_key | Access key of the Log Analytics Workspace to link with | `string` | n/a | yes |
| nic\_enable\_accelerated\_networking | Should Accelerated Networking be enabled? Defaults to `false`. | `bool` | `false` | no |
| nic\_nsg\_id | NSG ID to associate on the Network Interface. No association if null. | `string` | `null` | no |
| public\_ip\_sku | Sku for the public IP attached to the VM. Can be `null` if no public IP needed. | `string` | `"Standard"` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |
| static\_private\_ip | Static private IP. Private IP is dynamic if not set. | `string` | `null` | no |
| storage\_data\_disk\_config | Map to configure data storage disk. (Managed/Unmanaged, size...) | `map(map(string))` | `{}` | no |
| storage\_os\_disk\_config | Map to configure OS storage disk. (Managed/Unmanaged, size...) | `map(string)` | `{}` | no |
| subnet\_id | Id of the Subnet in which create the Virtual Machine | `string` | `null` | no |
| vm\_image | Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#storage_image_reference | `map(string)` | <pre>{<br>  "offer": "WindowsServer",<br>  "publisher": "MicrosoftWindowsServer",<br>  "sku": "2019-Datacenter",<br>  "version": "latest"<br>}</pre> | no |
| vm\_size | Size (SKU) of the Virtual Machin to create. | `string` | n/a | yes |
| zone\_id | Index of the Availability Zone which the Virtual Machine should be allocated in. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| vm\_id | Id of the Virtual machine |
| vm\_name | Name of the Virtual machine |
| vm\_nic\_id | ID of the Network Interface Configuration attached to the Virtual Machine |
| vm\_nic\_ip\_configuration\_name | Name of the IP Configuration for the Network Interface Configuration attached to the Virtual Machine |
| vm\_nic\_name | Name of the Network Interface Configuration attached to the Virtual Machine |
| vm\_private\_ip\_address | Private IP address of the Virtual machine |
| vm\_public\_domain\_name\_label | Public DNS of the Virtual machine |
| vm\_public\_ip\_address | Public IP address of the Virtual machine |
| vm\_winrm\_certificate\_data | The raw Key Vault Certificate. |
| vm\_winrm\_certificate\_key\_vault\_id | Id of the generated certificate in the input Key Vault |
| vm\_winrm\_certificate\_thumbprint | The X509 Thumbprint of the Key Vault Certificate returned as hex string. |

## Related documentation

Terraform resource documentation: [terraform.io/docs/providers/azurerm/r/virtual_machine.html](https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html)

Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/virtual-machines/windows/](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/)

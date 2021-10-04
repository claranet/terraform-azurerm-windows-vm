# Azure Windows Virtual Machine
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/windows-vm/azurerm/)

This module creates a [Windows Virtual Machine](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/) with
[Windows Remote Management (WinRM)](https://docs.microsoft.com/en-us/windows/desktop/WinRM/portal) activated.

The Windows Virtual Machine comes with:
* [Azure Monitor Agent](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/azure-monitor-agent-overview) activated and configured
* A link to a [Log Analytics Workspace](https://docs.microsoft.com/en-us/azure/azure-monitor/overview) for [logging](https://docs.microsoft.com/en-us/azure/azure-monitor/learn/quick-collect-azurevm) and [patching](https://docs.microsoft.com/en-us/azure/automation/automation-update-management) management
* An optional link to a [Load Balancer](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-overview) or [Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/overview)
* A link to the [Recovery Vault](https://docs.microsoft.com/en-us/azure/backup/backup-azure-recovery-services-vault-overview) and one of its policies to back up the virtual machine
* Optional certificates [retrieved from Azure Key Vault](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/key-vault-windows#extension-schema)

This code is mostly based on [Tom Harvey](https://github.com/tombuildsstuff) work: https://github.com/terraform-providers/terraform-provider-azurerm/tree/master/examples/virtual-machines/provisioners/windows

Following tags are automatically set with default values: `env`, `stack`, `os_family`, `os_distribution`, `os_version`.

## Limitations

* A self-signed certificate is generated and associated

## Requirements

* Powershell CLI installed with pwsh executable available
* [Azure powershell module](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps) installed
* The port 5986 must be reachable
* An [Azure Key Vault](https://docs.microsoft.com/en-us/azure/key-vault/) configured with VM deployment enabled will be used
* An existing [Log Analytics Workspace](https://docs.microsoft.com/en-us/azure/azure-monitor/overview) is mandatory for patching management
* An existing [Azure Monitor Data Collection Rule](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/data-collection-rule-overview) is mandatory for monitoring ang logging management with Azure Monitor Agent

## Ansible usage

The created virtual machine can be used with Ansible this way.

```bash
ansible all -i <public_ip_address>, -m win_ping -e ansible_user=<vm_username> -e ansible_password==<vm_password> -e ansible_connection=winrm -e ansible_winrm_server_cert_validation=ignore
```

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 5.x.x       | 0.15.x & 1.0.x    | >= 2.0          |
| >= 4.x.x       | 0.13.x            | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "azure_network_vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
  vnet_cidr           = ["10.10.0.0/16"]
}

module "azure_network_subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = module.azure_network_vnet.virtual_network_name
  subnet_cidr_list     = ["10.10.10.0/24"]

  route_table_name = module.azure_network_route_table.route_table_name

  network_security_group_name = module.network_security_group.network_security_group_name
}

module "network_security_group" {
  source  = "claranet/nsg/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
}

module "azure_network_route_table" {
  source  = "claranet/route-table/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
}

resource "azurerm_availability_set" "vm_avset" {
  name                = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-as"
  location            = module.azure_region.location
  resource_group_name = module.rg.resource_group_name
  managed             = true
}

module "run_common" {
  source  = "claranet/run-common/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name

  tenant_id                        = var.azure_tenant_id
  monitoring_function_splunk_token = null
}

module "key_vault" {
  source  = "claranet/keyvault/azurerm"
  version = "x.x.x"

  client_name = var.client_name
  environment = var.environment
  location    = module.azure_region.location
  stack       = var.stack

  resource_group_name = module.rg.resource_group_name

  # Mandatory for use with VM deployment
  enabled_for_deployment = "true"

  admin_objects_ids = var.keyvault_admin_objects_ids

  logs_destinations_ids = [
    module.run_common.logs_storage_account_id,
    module.run_common.log_analytics_workspace_id
  ]
}

resource "azurerm_network_security_rule" "winrm" {
  name = "Allow-winrm-rule"

  resource_group_name         = module.rg.resource_group_name
  network_security_group_name = module.network_security_group.network_security_group_name

  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "5986"
  source_address_prefixes    = [var.admin_ip_addresses]
  destination_address_prefix = "*"
}

module "az_vm_backup" {
  source  = "claranet/run-iaas/azurerm//modules/backup"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  logs_destinations_ids = [
    module.run_common.logs_storage_account_id,
    module.run_common.log_analytics_workspace_id
  ]
}

module "az_monitor" {
  source = "git::ssh://git@git.fr.clara.net/claranet/projects/cloud/azure/terraform/modules/run-iaas.git//modules/vm-monitoring?ref=AZ-302-vm-monitor"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name        = module.rg.resource_group_name
  log_analytics_workspace_id = module.run_common.log_analytics_workspace_id

  extra_tags = {
    foo = "bar"
  }
}

module "vm" {
  source  = "claranet/windows-vm/azurerm"
  version = "x.x.x"

  location            = module.azure_region.location
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name

  key_vault_id   = module.key_vault.key_vault_id
  subnet_id      = module.azure_network_subnet.subnet_id
  vm_size        = "Standard_B2s"
  admin_username = var.vm_administrator_login
  admin_password = var.vm_administrator_password

  diagnostics_storage_account_name      = module.run_common.logs_storage_account_name
  diagnostics_storage_account_key       = null # used by legacy agent only
  azure_monitor_data_collection_rule_id = module.az_monitor.data_collection_rule_id
  log_analytics_workspace_guid          = module.run_common.log_analytics_workspace_guid
  log_analytics_workspace_key           = module.run_common.log_analytics_workspace_primary_key

  # Set to null to deactivate backup
  backup_policy_id = module.az_vm_backup.vm_backup_policy_id

  availability_set_id = azurerm_availability_set.vm_avset.id
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
    disk_size_gb = "150" # At least 127 Gb
    caching      = "ReadWrite"
  }

  storage_data_disk_config = {
    app = {
      disk_size_gb         = 256
      lun                  = 0
      storage_account_type = "Premium_LRS"
    }
  }
}

```

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.0 |
| null | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| vm\_os\_disk\_tagging | claranet/tagging/azurerm | 4.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_backup_protected_vm.backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_protected_vm) | resource |
| [azurerm_key_vault_access_policy.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_certificate.winrm_certificate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate) | resource |
| [azurerm_managed_disk.disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_application_gateway_backend_address_pool_association.appgw_pool_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_gateway_backend_address_pool_association) | resource |
| [azurerm_network_interface_backend_address_pool_association.lb_pool_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_interface_security_group_association.nic_nsg_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_public_ip.public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_virtual_machine_data_disk_attachment.disk_attach](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_extension.azure_monitor_agent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.keyvault_certificates](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.log_extension](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_windows_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [null_resource.azure_monitor_link](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.winrm_connection_test](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_managed_disk.vm_os_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/managed_disk) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_password | Password for Virtual Machine administrator account | `string` | n/a | yes |
| admin\_username | Username for Virtual Machine administrator account | `string` | n/a | yes |
| application\_gateway\_backend\_pool\_id | Id of the Application Gateway Backend Pool to attach the VM. | `string` | `null` | no |
| attach\_application\_gateway | True to attach this VM to an Application Gateway | `bool` | `false` | no |
| attach\_load\_balancer | True to attach this VM to a Load Balancer | `bool` | `false` | no |
| availability\_set\_id | Id of the availability set in which host the Virtual Machine. | `string` | `null` | no |
| azure\_monitor\_agent\_version | Azure Monitor Agent extension version | `string` | `"1.1.2"` | no |
| azure\_monitor\_data\_collection\_rule\_id | Data Collection Rule ID from Azure Monitor for metrics and logs collection. Used with new monitoring agent, set to `null` if legacy agent is used. | `string` | n/a | yes |
| backup\_policy\_id | Backup policy ID from the Recovery Vault to attach the Virtual Machine to (value to `null` to disable backup) | `string` | n/a | yes |
| certificate\_validity\_in\_months | The created certificate validity in months | `string` | `"48"` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_dns\_label | The DNS label to use for public access. VM name if not set. DNS will be <label>.westeurope.cloudapp.azure.com | `string` | `""` | no |
| custom\_ipconfig\_name | Custom name for the IP config of the NIC. Should be suffixed by "-nic-ipconfig". Generated if not set. | `string` | `null` | no |
| custom\_name | Custom name for the Virtual Machine. Should be suffixed by "-vm". Generated if not set. | `string` | `""` | no |
| diagnostics\_storage\_account\_key | Access key of the Storage Account used for Virtual Machine diagnostics. Used only with legacy monitoring agent, set to `null` if not needed. | `string` | n/a | yes |
| diagnostics\_storage\_account\_name | Name of the Storage Account in used for Virtual Machine diagnostics | `string` | n/a | yes |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to set on each created resource. | `map(string)` | `{}` | no |
| key\_vault\_certificates\_names | List of Azure Key Vault certificates names to install in the VM | `list(string)` | `null` | no |
| key\_vault\_certificates\_polling\_rate | Polling rate (in seconds) for Key Vault certificates retrieval | `number` | `300` | no |
| key\_vault\_certificates\_store\_name | Name of the cetrificate store on which install the Key Vault certificates | `string` | `"MY"` | no |
| key\_vault\_id | Id of the Azure Key Vault to use for VM certificate | `string` | n/a | yes |
| license\_type | Specifies the BYOL Type for this Virtual Machine. Possible values are `Windows_Client` and `Windows_Server` if set. | `string` | `null` | no |
| load\_balancer\_backend\_pool\_id | Id of the Load Balancer Backend Pool to attach the VM. | `string` | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| log\_analytics\_agent\_version | Azure Log Analytics extension version | `string` | `"1.0"` | no |
| log\_analytics\_workspace\_guid | GUID of the Log Analytics Workspace to link with | `string` | n/a | yes |
| log\_analytics\_workspace\_key | Access key of the Log Analytics Workspace to link with | `string` | n/a | yes |
| nic\_enable\_accelerated\_networking | Should Accelerated Networking be enabled? Defaults to `false`. | `bool` | `false` | no |
| nic\_extra\_tags | Extra tags to set on the network interface. | `map(string)` | `{}` | no |
| nic\_nsg\_id | NSG ID to associate on the Network Interface. No association if null. | `string` | `null` | no |
| os\_disk\_extra\_tags | Extra tags to set on the OS disk. | `map(string)` | `{}` | no |
| public\_ip\_extra\_tags | Extra tags to set on the Public IP. | `map(string)` | `{}` | no |
| public\_ip\_sku | Sku for the public IP attached to the VM. Can be `null` if no public IP needed. | `string` | `"Standard"` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |
| static\_private\_ip | Static private IP. Private IP is dynamic if not set. | `string` | `null` | no |
| storage\_data\_disk\_config | Map of data disks to attach to the Virtual Machine. Map attributes: `storage_account_type` (optional, defaults to `Standard_LRS`), `create_option` (optional, defaults to `Empty`), `disk_size_gb`, `lun` & `caching` (optional, defaults to `ReadWrite`). See [virtual\_machine\_data\_disk\_attachment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) & [managed\_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | `map(any)` | `{}` | no |
| storage\_os\_disk\_config | Map to configure OS storage disk. (Caching, size, storage account type...) | `map(string)` | `{}` | no |
| subnet\_id | Id of the Subnet in which create the Virtual Machine | `string` | `null` | no |
| use\_legacy\_monitoring\_agent | True to use the legacy monitoring agent instead of Azure Monitor Agent | `bool` | `false` | no |
| vm\_image | Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/windows_virtual_machine.html#source_image_reference | `map(string)` | <pre>{<br>  "offer": "WindowsServer",<br>  "publisher": "MicrosoftWindowsServer",<br>  "sku": "2019-Datacenter",<br>  "version": "latest"<br>}</pre> | no |
| vm\_image\_id | The ID of the Image which this Virtual Machine should be created from. This variable supersedes the `vm_image` variable if not null. | `string` | `null` | no |
| vm\_size | Size (SKU) of the Virtual Machine to create. | `string` | n/a | yes |
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
<!-- END_TF_DOCS -->

## Related documentation

Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/virtual-machines/windows/](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/)

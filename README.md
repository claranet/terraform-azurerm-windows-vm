# Azure Windows Virtual Machine

This module creates a [Windows Virtual Machine](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/) with 
[Windows Remote Management (WinRM)](https://docs.microsoft.com/en-us/windows/desktop/WinRM/portal) activated.

This code is mostly based on [Tom Harvey](https://github.com/tombuildsstuff) work: https://github.com/terraform-providers/terraform-provider-azurerm/tree/master/examples/virtual-machines/provisioners/windows

## Limitations

* The Virtual Machine is public
* A self-signed certificate is generated and associated

## Requirements

* The port 5986 must be reachable
* An Azure Key Vault configured with VM deployment enabled will be used

## Usage

```hcl
module "azure-region" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/regions.git?ref=vX.X.X"

  azure_region = "${var.azure_region}"
}

module "rg" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/rg.git?ref=vX.X.X"

  location    = "${module.azure-region.location}"
  client_name = "${var.client_name}"
  environment = "${var.environment}"
  stack       = "${var.stack}"
}

module "azure-network-vnet" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/vnet.git?ref=vX.X.X"
    
  environment      = "${var.environment}"
  location         = "${module.azure-region.location}"
  location_short   = "${module.azure-region.location_short}"
  client_name      = "${var.client_name}"
  stack            = "${var.stack}"

  resource_group_name = "${module.rg.resource_group_name}"
  vnet_cidr           = ["10.10.0.0/16"]
}

module "network-security-group" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/nsg.git?ref=vX.X.X"

  client_name         = "${var.client_name}"
  environment         = "${var.environment}"
  stack               = "${var.stack}"
  resource_group_name = "${module.rg.resource_group_name}"
  location            = "${module.azure-region.location}"
  location_short      = "${module.azure-region.location_short}"
}

module "azure-network-subnet" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/subnet.git?ref=vX.X.X"

  environment         = "${var.environment}"
  location_short      = "${module.azure-region.location_short}"
  client_name         = "${var.client_name}"
  stack			      = "${var.stack}"

  resource_group_name  = "${module.rg.resource_group_name}"
  virtual_network_name = "${module.azure-network-vnet.virtual_network_name}"
  subnet_cidr_list     = ["10.10.10.0/24"]

  network_security_group_count = 1
  network_security_group_ids   = ["${module.network-security-group.network_security_group_id}"]
}

resource "azurerm_network_security_rule" "winrm" {
  name = "Allow-winrm-rule"

  resource_group_name         = "${module.rg.resource_group_name}"
  network_security_group_name = "${module.network-security-group.network_security_group_name}"

  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "5986"
  source_address_prefixes    = ["${local.admin_ip_addresses}"]
  destination_address_prefix = "*"
}

module "key_vault" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/keyvault.git?ref=vX.X.X"

  client_name         = "${var.client_name}"
  environment         = "${var.environment}"
  location            = "${module.azure-region.location}"
  location_short      = "${module.azure-region.location_short}"
  resource_group_name = "${module.rg.resource_group_name}"
  stack               = "${var.stack}"

  # Mandatory for use with VM deployment
  enabled_for_deployment = "true"

  admin_objects_ids = ["${local.keyvault_admin_objects_ids}"]
}

resource "azurerm_availability_set" "vm_avset" {
  name                = "${var.stack}-${var.client_name}-${module.az-region.location_short}-${var.environment}-as"
  location            = "${module.az-region.location}"
  resource_group_name = "${module.rg.resource_group_name}"
  managed             = "true"
}

module "vm" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/features/windows-virtual-machine.git?ref=vX.X.X"

  location            = "${module.azure-region.location}"
  location_short      = "${module.azure-region.location_short}"
  client_name         = "${var.client_name}"
  environment         = "${var.environment}"
  stack               = "${var.stack}"
  resource_group_name = "${module.rg.resource_group_name}"

  key_vault_id        = "${module.key_vault.key_vault_id}"
  subnet_id           = "${element(module.azure-network-subnet.subnet_ids, 0)}"
  vm_size             = "Standard_B2s"
  custom_name         = "${local.vm_name}"
  admin_username      = "${var.vm_admin_username}"
  admin_password      = "${var.vm_admin_password}"
  availability_set_id = "${azurerm_availability_set.vm_avset.id}"

  vm_image = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter-with-Containers"
    version   = "latest"
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
|------|-------------|:----:|:-----:|:-----:|
| admin\_password | Password for Virtual Machine administrator account | string | n/a | yes |
| admin\_username | Username for Virtual Machine administrator account | string | n/a | yes |
| availability\_set\_id | Id to the Vailability set in which host the Virtual Machine. | string | n/a | yes |
| client\_name | Client name/account used in naming | string | n/a | yes |
| custom\_name | Custom name for the Virtual Machine. Should be suffixed by "-vm". Generated if not set. | string | `""` | no |
| delete\_data\_disks\_on\_termination | Should the Data Disks (either the Managed Disks / VHD Blobs) be deleted when the Virtual Machine is destroyed? | string | `"false"` | no |
| delete\_os\_disk\_on\_termination | Should the OS Disk (either the Managed Disk / VHD Blob) be deleted when the Virtual Machine is destroyed? | string | `"false"` | no |
| environment | Project environment | string | n/a | yes |
| extra\_tags |  | map | `<map>` | no |
| key\_vault\_id | Id of the Azure Key Vault to use for VM certificate | string | n/a | yes |
| location | Azure location. | string | n/a | yes |
| location\_short | Short string for Azure location. | string | n/a | yes |
| resource\_group\_name | Resource group name | string | n/a | yes |
| stack | Project stack name | string | n/a | yes |
| subnet\_id | Id of the Subnet in which create the Virtual Machine | string | n/a | yes |
| vm\_image | Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#storage_image_reference | map | `<map>` | no |
| vm\_size | Size (SKU) of the Virtual Machin to create. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| vm\_id | Id of the Virtual machine |
| vm\_name | Name of the Virtual machine |
| vm\_private\_ip\_address | Private IP address of the Virtual machine |
| vm\_public\_ip\_address | Public IP address of the Virtual machine |
| vm\_winrm\_certificate\_key\_vault\_id | Id of the generated certificate in the input Key Vault |

## Related documentation

Terraform resource documentation: [https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html]

Microsoft Azure documentation: [https://docs.microsoft.com/en-us/azure/virtual-machines/windows/]

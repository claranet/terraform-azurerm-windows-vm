# Retrieve the existing Entra groups to which we want to assign login access on the Windows Virtual Machine
data "azuread_group" "vm_admins_group" {
  display_name = "Virtual Machines Administrators"
}

data "azuread_group" "vm_users_group" {
  display_name = "Virtual Machines Basic Users"
}

resource "azurerm_availability_set" "main" {
  name                = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-as"
  location            = module.azure_region.location
  resource_group_name = module.rg.name
  managed             = true
}

module "vm" {
  source  = "claranet/windows-vm/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  key_vault = {
    id = module.run.key_vault_id
  }

  subnet = module.subnet

  vm_size        = "Standard_B2s"
  admin_username = var.vm_admin_login
  admin_password = var.vm_admin_password

  diagnostics_storage_account_name = module.run.logs_storage_account_name
  azure_monitor_data_collection_rule = {
    id = module.run.data_collection_rule_id
  }

  # Set to null to deactivate backup
  backup_policy = {
    id = module.run.vm_backup_policy_id
  }

  patch_mode = "AutomaticByPlatform"
  maintenance_configurations_ids = [
    module.run.maintenance_configurations["Donald"].id,
    module.run.maintenance_configurations["Hammer"].id,
  ]

  availability_set = azurerm_availability_set.main
  # or use Availability Zone
  # zone_id = 1

  vm_image = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter-with-Containers"
    version   = "latest"
  }

  # The feature must be activated upstream:
  # az feature register --namespace Microsoft.Compute --name EncryptionAtHost --subscription <subscription_id_or_name>
  encryption_at_host_enabled = true

  # Use unmanaged disk if needed
  # If those blocks are not defined, it will use managed_disks
  os_disk_size_gb = "150" # At least 127 Gb
  os_disk_caching = "ReadWrite"

  storage_data_disk_config = {
    app = {
      disk_size_gb         = 256
      lun                  = 0
      storage_account_type = "Premium_LRS"
    }
  }

  entra_login_enabled = true
  entra_login_user_objects_ids = [
    data.azuread_group.vm_users_group.object_id,
  ]
  entra_login_admin_objects_ids = [
    data.azuread_group.vm_admins_group.object_id,
  ]
}

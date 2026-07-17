resource "azurerm_key_vault_secret" "cert" {
  name         = format("%s-cert", local.name)
  value        = var.certificate
  key_vault_id = module.run.key_vault_id

  lifecycle { prevent_destroy = true }
}

resource "azurerm_key_vault_secret" "private_key" {
  name         = format("%s-private-key", local.name)
  value        = var.private_key
  key_vault_id = module.run.key_vault_id

  lifecycle { prevent_destroy = true }
}

module "vm" {
  source  = "claranet/windows-vm/azurerm"
  version = "x.x.x"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.name

  key_vault = {
    id = module.run.key_vault_id

    winrm_certificate_enabled = true

    # Allow VM to access its own TLS secrets
    scopes = {
      cert = azurerm_key_vault_secret.cert.resource_versionless_id
      key  = azurerm_key_vault_secret.private_key.resource_versionless_id
    }
  }

  key_vault_certificates = {
    names      = var.key_vault_certificate_names
    store_name = "MY"
  }

  subnet = {
    id = module.subnet.id
  }

  vm_size        = "Standard_B2s"
  admin_username = var.vm_administrator_login
  admin_password = var.vm_administrator_password

  diagnostics_storage_account_name = module.run.logs_storage_account_name
  azure_monitor_data_collection_rule = {
    id = module.run.data_collection_rule_id
  }

  backup_policy = {
    id = module.run.vm_backup_policy_id
  }

  vm_image = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }
}

module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack
}

module "vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  cidrs = ["10.10.0.0/16"]
}

module "subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  virtual_network_name        = module.vnet.name
  network_security_group_name = module.nsg.name
  route_table_name            = module.route_table.name

  cidrs = ["10.10.10.0/24"]
}

module "nsg" {
  source  = "claranet/nsg/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  winrm_inbound_allowed = true
  winrm_source_allowed  = var.vm_admin_ip_addresses # "*"
}

module "route_table" {
  source  = "claranet/route-table/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name
}

module "run" {
  source  = "claranet/run/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  monitoring_function_enabled = false
  vm_monitoring_enabled       = true
  backup_vm_enabled           = true
  update_center_enabled       = true

  update_center_periodic_assessment_enabled = true
  update_center_periodic_assessment_scopes  = [module.rg.id]
  update_center_maintenance_configurations = [
    {
      configuration_name = "Donald"
      start_date_time    = "2021-08-21 04:00"
      recur_every        = "1Day"
    },
    {
      configuration_name = "Hammer"
      start_date_time    = "1900-01-01 03:00"
      recur_every        = "1Week"
    }
  ]

  recovery_vault_cross_region_restore_enabled = true
  vm_backup_daily_policy_retention            = 31

  key_vault_enabled_for_deployment = true
  key_vault_admin_objects_ids      = var.key_vault_admin_objects_ids
}

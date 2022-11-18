# azurerm_maintenance_assignment_virtual_machine does not support this maintenance scope yet.
resource "azapi_resource" "maintenance_configurations" {
  for_each  = toset(var.maintenance_configuration_ids)
  name      = format("%s-%s", azurerm_windows_virtual_machine.vm.name, split("/", each.value)[8]) # vmname-maintenance-name
  location  = azurerm_windows_virtual_machine.vm.location
  parent_id = azurerm_windows_virtual_machine.vm.id
  type      = "Microsoft.Maintenance/configurationAssignments@2022-07-01-preview"
  body = jsonencode({
    properties = {
      maintenanceConfigurationId = lower(each.value)
      resourceId                 = lower(azurerm_windows_virtual_machine.vm.id)
    }
  })
  response_export_values  = ["*"]
  ignore_missing_property = true

  lifecycle {
    precondition {
      condition     = var.patch_mode == "AutomaticByPlatform"
      error_message = "The variable patch_mode must be set to AutomaticByPlatform to use maintenance configurations."
    }
    ignore_changes = [location]
  }
}


resource "azurerm_maintenance_assignment_virtual_machine" "main" {
  for_each = toset(var.maintenance_configurations_ids)

  location = var.location

  virtual_machine_id = azurerm_windows_virtual_machine.main.id

  maintenance_configuration_id = each.value

  lifecycle {
    precondition {
      condition     = var.patch_mode == "AutomaticByPlatform"
      error_message = "`var.patch_mode` must be set to `AutomaticByPlatform` to use maintenance configurations."
    }
  }
}

moved {
  from = azurerm_maintenance_assignment_virtual_machine.maintenance_configurations
  to   = azurerm_maintenance_assignment_virtual_machine.main
}

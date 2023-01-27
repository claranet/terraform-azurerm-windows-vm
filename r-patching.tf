resource "azurerm_maintenance_assignment_virtual_machine" "maintenance_configurations" {
  for_each                     = toset(var.maintenance_configuration_ids)
  location                     = azurerm_windows_virtual_machine.vm.location
  maintenance_configuration_id = each.value
  virtual_machine_id           = azurerm_windows_virtual_machine.vm.id

  lifecycle {
    precondition {
      condition     = var.patch_mode == "AutomaticByPlatform"
      error_message = "The variable patch_mode must be set to AutomaticByPlatform to use maintenance configurations."
    }
  }
}

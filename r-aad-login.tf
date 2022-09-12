resource "azurerm_virtual_machine_extension" "aad_login" {
  for_each = toset(var.aad_login_enabled ? ["enabled"] : [])

  name                       = "${azurerm_windows_virtual_machine.vm.name}-AADLoginForWindows"
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = var.aad_login_extension_version
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  auto_upgrade_minor_version = false
  automatic_upgrade_enabled  = false
}

resource "azurerm_role_assignment" "rbac_user_login" {
  for_each             = toset(var.aad_login_enabled ? var.aad_login_user_objects_ids : [])
  principal_id         = each.value
  scope                = azurerm_windows_virtual_machine.vm.id
  role_definition_name = "Virtual Machine User Login"
}

resource "azurerm_role_assignment" "rbac_admin_login" {
  for_each             = toset(var.aad_login_enabled ? var.aad_login_admin_objects_ids : [])
  principal_id         = each.value
  scope                = azurerm_windows_virtual_machine.vm.id
  role_definition_name = "Virtual Machine Administrator Login"
}

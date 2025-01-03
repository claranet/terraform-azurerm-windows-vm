resource "azurerm_virtual_machine_extension" "entra_login" {
  count = var.entra_login_enabled ? 1 : 0

  name = "${azurerm_windows_virtual_machine.main.name}-AADLoginForWindows"

  publisher            = "Microsoft.Azure.ActiveDirectory"
  type                 = "AADLoginForWindows"
  type_handler_version = var.entra_login_extension_version

  virtual_machine_id = azurerm_windows_virtual_machine.main.id

  auto_upgrade_minor_version = false
  automatic_upgrade_enabled  = false

  tags = merge(local.default_tags, var.extra_tags, var.extensions_extra_tags)
}

moved {
  from = azurerm_virtual_machine_extension.aad_login["enabled"]
  to   = azurerm_virtual_machine_extension.entra_login[0]
}

resource "azurerm_role_assignment" "rbac_user_login" {
  for_each             = toset(var.entra_login_enabled ? var.entra_login_user_objects_ids : [])
  principal_id         = each.value
  scope                = azurerm_windows_virtual_machine.main.id
  role_definition_name = "Virtual Machine User Login"
}

resource "azurerm_role_assignment" "rbac_admin_login" {
  for_each             = toset(var.entra_login_enabled ? var.entra_login_admin_objects_ids : [])
  principal_id         = each.value
  scope                = azurerm_windows_virtual_machine.main.id
  role_definition_name = "Virtual Machine Administrator Login"
}

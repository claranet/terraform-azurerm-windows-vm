resource "azurerm_virtual_machine_extension" "aad_login" {
  name                       = "${azurerm_windows_virtual_machine.vm.name}-AADLoginForWindows"
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = var.aad_login_extension_version
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  auto_upgrade_minor_version = true
}

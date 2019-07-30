data "template_file" "diagnostics" {
  template = file(format("%s/files/diagnostics.json", path.module))

  vars = {
    resource_id  = azurerm_virtual_machine.vm.id
    storage_name = var.diagnostics_storage_account_name
  }
}

resource "azurerm_virtual_machine_extension" "diagnostics" {
  name = "${azurerm_virtual_machine.vm.name}-diagnosticsextension"

  location            = var.location
  resource_group_name = var.resource_group_name

  publisher                  = "Microsoft.Azure.Diagnostics"
  type                       = "IaaSDiagnostics"
  type_handler_version       = "1.16"
  auto_upgrade_minor_version = "true"

  virtual_machine_name = azurerm_virtual_machine.vm.name

  settings = data.template_file.diagnostics.rendered

  protected_settings = <<SETTINGS
  {
    "storageAccountName": "${var.diagnostics_storage_account_name}",
    "storageAccountKey": "${var.diagnostics_storage_account_key}"
  }
SETTINGS
}

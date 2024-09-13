resource "azurerm_virtual_machine_extension" "diagnostics" {
  for_each = toset(var.use_legacy_monitoring_agent ? ["enabled"] : [])

  name = "${azurerm_windows_virtual_machine.vm.name}-diagnosticsextension"

  publisher                  = "Microsoft.Azure.Diagnostics"
  type                       = "IaaSDiagnostics"
  type_handler_version       = "1.16"
  auto_upgrade_minor_version = "true"

  virtual_machine_id = azurerm_windows_virtual_machine.vm.id

  settings = templatefile(format("%s/files/diagnostics.json", path.module), {
    resource_id  = azurerm_windows_virtual_machine.vm.id
    storage_name = var.diagnostics_storage_account_name
  })

  protected_settings = <<SETTINGS
  {
    "storageAccountName": "${var.diagnostics_storage_account_name}",
    "storageAccountKey": "${var.diagnostics_storage_account_key}"
  }
SETTINGS

  tags = merge(local.default_tags, var.extra_tags, var.extensions_extra_tags)

  lifecycle {
    precondition {
      condition     = var.diagnostics_storage_account_key != null
      error_message = "Variable diagnostics_storage_account_key must be set when legacy monitoring agent is enabled."
    }
  }
}

resource "azurerm_virtual_machine_extension" "azure_monitor_agent" {
  for_each = toset(var.use_legacy_monitoring_agent ? [] : ["enabled"])

  name = "${azurerm_windows_virtual_machine.vm.name}-azmonitorextension"

  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = var.azure_monitor_agent_version
  auto_upgrade_minor_version = "true"
  automatic_upgrade_enabled  = var.azure_monitor_agent_auto_upgrade_enabled

  virtual_machine_id = azurerm_windows_virtual_machine.vm.id

  settings = local.ama_settings

  tags = merge(local.default_tags, var.extra_tags, var.extensions_extra_tags)
}

resource "azurerm_monitor_data_collection_rule_association" "dcr" {
  for_each = toset(var.use_legacy_monitoring_agent ? [] : ["enabled"])

  name                    = local.dcr_name
  target_resource_id      = azurerm_windows_virtual_machine.vm.id
  data_collection_rule_id = var.azure_monitor_data_collection_rule_id
}

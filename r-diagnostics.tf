resource "azurerm_virtual_machine_extension" "azure_monitor_agent" {
  count = var.monitoring_agent_enabled ? 1 : 0

  name = "${azurerm_windows_virtual_machine.main.name}-azmonitorextension"

  publisher            = "Microsoft.Azure.Monitor"
  type                 = "AzureMonitorWindowsAgent"
  type_handler_version = var.azure_monitor_agent_version

  virtual_machine_id = azurerm_windows_virtual_machine.main.id

  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = var.azure_monitor_agent_auto_upgrade_enabled

  settings = local.ama_settings

  tags = merge(local.default_tags, var.extra_tags, var.extensions_extra_tags)
}

moved {
  from = azurerm_virtual_machine_extension.azure_monitor_agent["enabled"]
  to   = azurerm_virtual_machine_extension.azure_monitor_agent[0]
}

resource "azurerm_monitor_data_collection_rule_association" "main" {
  count = var.azure_monitor_data_collection_rule != null ? 1 : 0

  name                    = local.dcr_name
  target_resource_id      = azurerm_windows_virtual_machine.main.id
  data_collection_rule_id = var.azure_monitor_data_collection_rule.id
}

moved {
  from = azurerm_monitor_data_collection_rule_association.dcr["enabled"]
  to   = azurerm_monitor_data_collection_rule_association.main[0]
}

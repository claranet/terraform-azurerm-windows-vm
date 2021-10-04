resource "azurerm_virtual_machine_extension" "diagnostics" {
  for_each = var.use_legacy_monitoring_agent ? ["enabled"] : []

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
}

resource "azurerm_virtual_machine_extension" "azure_monitor_agent" {
  for_each = var.use_legacy_monitoring_agent ? [] : ["enabled"]

  name = "${azurerm_windows_virtual_machine.vm.name}-azmonitorextension"

  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = var.azure_monitor_agent_version
  auto_upgrade_minor_version = "true"

  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
}

resource "null_resource" "azure_monitor_link" {
  for_each = var.use_legacy_monitoring_agent ? [] : ["enabled"]

  provisioner "local-exec" {
    command = <<EOC
      az rest --subscription ${data.azurerm_client_config.current.subscription_id} \
              --method PUT \
              --url https://management.azure.com${azurerm_windows_virtual_machine.vm.id}/providers/Microsoft.Insights/dataCollectionRuleAssociations/${azurerm_windows_virtual_machine.vm.name}-dcrassociation?api-version=2019-11-01-preview \
              --body '{"properties":{"dataCollectionRuleId": "${var.azure_monitor_data_collection_rule_id}"}}'
EOC
  }

  triggers = {
    dcr_id = var.azure_monitor_data_collection_rule_id
    vm_id  = azurerm_windows_virtual_machine.vm.id
  }
}

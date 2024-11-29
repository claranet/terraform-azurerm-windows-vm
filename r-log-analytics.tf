resource "azurerm_virtual_machine_extension" "log_analytics_extension" {
  count = var.log_analytics_agent_enabled ? 1 : 0

  name = "${azurerm_windows_virtual_machine.main.name}-logextension"

  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "MicrosoftMonitoringAgent"
  type_handler_version = var.log_analytics_agent_version

  virtual_machine_id = azurerm_windows_virtual_machine.main.id

  auto_upgrade_minor_version = true

  settings = jsonencode({
    workspaceId = var.log_analytics_workspace_guid
  })
  protected_settings = jsonencode({
    workspaceKey = var.log_analytics_workspace_key
  })

  tags = merge(local.default_tags, var.extra_tags, var.extensions_extra_tags)

  lifecycle {
    precondition {
      condition     = var.log_analytics_workspace_guid != null && var.log_analytics_workspace_key != null
      error_message = "`var.log_analytics_workspace_guid` and `var.log_analytics_workspace_key` must be set when Log Analytics agent is enabled."
    }
  }
}

moved {
  from = azurerm_virtual_machine_extension.log_extension["enabled"]
  to   = azurerm_virtual_machine_extension.log_analytics_extension[0]
}

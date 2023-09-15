resource "azurerm_virtual_machine_extension" "log_extension" {
  for_each = toset(var.log_analytics_agent_enabled ? ["enabled"] : [])

  name = "${azurerm_windows_virtual_machine.vm.name}-logextension"

  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = var.log_analytics_agent_version
  auto_upgrade_minor_version = true

  virtual_machine_id = azurerm_windows_virtual_machine.vm.id

  settings = <<SETTINGS
  {
    "workspaceId": "${var.log_analytics_workspace_guid}"
  }
SETTINGS

  protected_settings = <<SETTINGS
  {
    "workspaceKey": "${var.log_analytics_workspace_key}"
  }
SETTINGS

  tags = merge(local.default_tags, var.extra_tags, var.extensions_extra_tags)

  lifecycle {
    precondition {
      condition     = var.log_analytics_workspace_guid != null && var.log_analytics_workspace_key != null
      error_message = "Variables log_analytics_workspace_guid and log_analytics_workspace_key must be set when Log Analytics agent is enabled."
    }
  }
}

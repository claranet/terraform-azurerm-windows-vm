variable "diagnostics_storage_account_name" {
  description = "Name of the Storage Account in which store boot diagnostics and for legacy monitoring agent."
  type        = string
  default     = null
}

variable "diagnostics_storage_account_key" {
  description = "Access key of the Storage Account used for Virtual Machine diagnostics. Used only with legacy monitoring agent, set to `null` if not needed."
  type        = string
  default     = null
}

## Logs & monitoring variables
variable "use_legacy_monitoring_agent" {
  description = "True to use the legacy monitoring agent instead of Azure Monitor Agent."
  type        = bool
  default     = false
}

variable "log_analytics_workspace_guid" {
  description = "GUID of the Log Analytics Workspace to link with."
  type        = string
  default     = null
}

variable "log_analytics_workspace_key" {
  description = "Access key of the Log Analytics Workspace to link with."
  type        = string
  default     = null
}

variable "azure_monitor_data_collection_rule_id" {
  description = "Data Collection Rule ID from Azure Monitor for metrics and logs collection. Used with new monitoring agent, set to `null` if legacy agent is used."
  type        = string
}

variable "azure_monitor_agent_version" {
  description = "Azure Monitor Agent extension version (https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-extension-versions)."
  type        = string
  default     = "1.13" # May 2023
}

variable "azure_monitor_agent_auto_upgrade_enabled" {
  description = "Automatically update agent when publisher releases a new version of the agent."
  type        = bool
  default     = false
}

variable "log_analytics_agent_enabled" {
  description = "Deploy Log Analytics VM extension - depending of OS (cf. https://docs.microsoft.com/fr-fr/azure/azure-monitor/agents/agents-overview#linux)"
  type        = bool
  default     = false
}

variable "log_analytics_agent_version" {
  description = "Azure Log Analytics extension version."
  type        = string
  default     = "1.0"
}

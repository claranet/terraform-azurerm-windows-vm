locals {
  custom_data_params  = "Param($ComputerName = \"${local.name}\")"
  custom_data_content = var.custom_data != null ? var.custom_data : "${local.custom_data_params} ${file(format("%s/files/winrm.ps1", path.module))}"

  backup_resource_group_name = var.backup_policy != null ? split("/", var.backup_policy.id)[4] : null
  backup_recovery_vault_name = var.backup_policy != null ? split("/", var.backup_policy.id)[8] : null

  key_vault_name = var.key_vault != null ? reverse(split("/", var.key_vault.id))[0] : null

  admin_password_encoded = replace(replace(replace(replace(replace(var.admin_password, "&[^#]", "&#38;"), ">", "&#62;"), "<", "&#60;"), "'", "&#39;"), "\"", "&#34;")
  additional_unattend_content = {
    # Auto-Login's required to configure WinRM
    AutoLogon = "<AutoLogon><Password><Value>${local.admin_password_encoded}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.admin_username}</Username></AutoLogon>"

    # Unattend config is to enable basic auth in WinRM, required for the provisioner stage
    FirstLogonCommands = file(format("%s/files/FirstLogonCommands.xml", path.module))
  }

  identity = var.azure_monitor_agent_user_assigned_identity != null || try(var.identity.type == "UserAssigned", false) ? {
    type         = join(", ", toset(compact(["UserAssigned", try(var.identity.type, "")])))
    identity_ids = compact(concat(try(var.identity.identity_ids, []), [var.azure_monitor_agent_user_assigned_identity]))
  } : var.identity

  ama_settings = var.azure_monitor_agent_user_assigned_identity != null ? jsonencode({
    authentication = {
      managedIdentity = {
        identitier-name  = "mi_res_id"
        identifier-value = var.azure_monitor_agent_user_assigned_identity
      }
    }
  }) : null
}

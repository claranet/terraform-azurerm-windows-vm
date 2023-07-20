locals {
  custom_data_params  = "Param($ComputerName = \"${local.vm_name}\")"
  custom_data_content = var.custom_data != null ? var.custom_data : "${local.custom_data_params} ${file(format("%s/files/winrm.ps1", path.module))}"

  admin_password_encoded = replace(replace(replace(replace(replace(var.admin_password, "&[^#]", "&#38;"), ">", "&#62;"), "<", "&#60;"), "'", "&#39;"), "\"", "&#34;")

  backup_resource_group_name = var.backup_policy_id != null ? split("/", var.backup_policy_id)[4] : null
  backup_recovery_vault_name = var.backup_policy_id != null ? split("/", var.backup_policy_id)[8] : null

  key_vault_name = var.key_vault_id != null ? split("/", var.key_vault_id)[8] : null

  additional_unattend_content = {
    # Auto-Login's required to configure WinRM
    AutoLogon = "<AutoLogon><Password><Value>${local.admin_password_encoded}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.admin_username}</Username></AutoLogon>"

    # Unattend config is to enable basic auth in WinRM, required for the provisioner stage.
    FirstLogonCommands = file(format("%s/files/FirstLogonCommands.xml", path.module))
  }
}

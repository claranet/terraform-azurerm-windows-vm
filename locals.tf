locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  vm_name = coalesce(
    var.custom_name,
    format("%s-%s-vm", var.client_name, var.environment),
  )

  ip_configuration_name = "configuration"

  custom_data_params = "Param($ComputerName = \"${local.vm_name}\")"

  custom_data_content = "${local.custom_data_params} ${file(format("%s/files/winrm.ps1", path.module))}"

  admin_password_encoded = replace(replace(replace(replace(replace(var.admin_password, "&[^#]", "&#38;"), ">", "&#62;"), "<", "&#60;"), "'", "&#39;"), "\"", "&#34;")
}

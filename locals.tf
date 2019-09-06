locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  vm_name = coalesce(
    var.custom_name,
    format("%s-%s-vm", var.client_name, var.environment),
  )

  custom_data_params = "Param($ComputerName = \"${local.vm_name}\")"

  custom_data_content = "${local.custom_data_params} ${file(format("%s/files/winrm.ps1", path.module))}"
}

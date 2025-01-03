locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  name                  = coalesce(var.custom_name, data.azurecaf_name.vm.result)
  hostname              = coalesce(var.computer_name, data.azurecaf_name.hostname.result)
  os_disk_name          = coalesce(var.os_disk_custom_name, "${local.name}-osdisk")
  public_ip_name        = coalesce(var.public_ip_custom_name, data.azurecaf_name.public_ip.result)
  nic_name              = coalesce(var.nic_custom_name, data.azurecaf_name.nic.result)
  ip_configuration_name = coalesce(var.ip_configuration_custom_name, "${local.name}-nic-ipconfig")
  dcr_name              = coalesce(var.dcr_custom_name, format("dcra-%s", azurerm_windows_virtual_machine.main.name))
}

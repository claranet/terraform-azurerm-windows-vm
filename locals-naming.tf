locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  vm_name               = coalesce(var.custom_name, data.azurecaf_name.vm.result)
  vm_hostname           = coalesce(var.custom_computer_name, data.azurecaf_name.hostname.result)
  vm_os_disk_name       = coalesce(var.os_disk_custom_name, "${local.vm_name}-osdisk")
  vm_pub_ip_name        = coalesce(var.custom_public_ip_name, data.azurecaf_name.pub_ip.result)
  vm_nic_name           = coalesce(var.custom_nic_name, data.azurecaf_name.nic.result)
  ip_configuration_name = coalesce(var.custom_ipconfig_name, "${local.vm_name}-nic-ipconfig")
  dcr_name              = coalesce(var.custom_dcr_name, format("dcra-%s", azurerm_windows_virtual_machine.vm.name))
}

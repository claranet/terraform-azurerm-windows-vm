data "azurerm_managed_disk" "vm_os_disk" {
  name                = lookup(var.storage_os_disk_config, "name", local.vm_os_disk_name)
  resource_group_name = var.resource_group_name

  depends_on = [azurerm_windows_virtual_machine.vm]
}

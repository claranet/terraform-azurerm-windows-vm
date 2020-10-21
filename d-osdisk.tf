data "azurerm_managed_disk" "vm_os_disk" {
  name                = lookup(var.storage_os_disk_config, "name", "${local.vm_name}-osdisk")
  resource_group_name = var.resource_group_name
}

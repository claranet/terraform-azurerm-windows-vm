resource "azurerm_windows_virtual_machine" "vm" {
  name                = local.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name

  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.vm_size
  license_type          = var.license_type

  tags = merge(local.default_tags, local.default_vm_tags, var.extra_tags)

  source_image_id = var.vm_image_id

  dynamic "source_image_reference" {
    for_each = var.vm_image_id == null ? ["fake"] : []
    content {
      offer     = lookup(var.vm_image, "offer", null)
      publisher = lookup(var.vm_image, "publisher", null)
      sku       = lookup(var.vm_image, "sku", null)
      version   = lookup(var.vm_image, "version", null)
    }
  }

  availability_set_id = var.availability_set_id

  zone = var.zone_id == null ? null : var.zone_id

  boot_diagnostics {
    storage_account_uri = "https://${var.diagnostics_storage_account_name}.blob.core.windows.net"
  }

  os_disk {
    name                 = lookup(var.storage_os_disk_config, "name", local.vm_os_disk_name)
    caching              = lookup(var.storage_os_disk_config, "caching", "ReadWrite")
    storage_account_type = lookup(var.storage_os_disk_config, "storage_account_type", "Premium_ZRS")
    disk_size_gb         = lookup(var.storage_os_disk_config, "disk_size_gb", null)
  }

  computer_name  = local.vm_hostname
  admin_username = var.admin_username
  admin_password = var.admin_password
  custom_data    = base64encode(local.custom_data_content)

  secret {
    key_vault_id = var.key_vault_id

    certificate {
      url   = azurerm_key_vault_certificate.winrm_certificate.secret_id
      store = "My"
    }
  }

  provision_vm_agent       = true
  enable_automatic_updates = true

  # Auto-Login's required to configure WinRM
  additional_unattend_content {
    setting = "AutoLogon"
    content = "<AutoLogon><Password><Value>${local.admin_password_encoded}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.admin_username}</Username></AutoLogon>"
  }

  # Unattend config is to enable basic auth in WinRM, required for the provisioner stage.
  additional_unattend_content {
    setting = "FirstLogonCommands"
    content = file(format("%s/files/FirstLogonCommands.xml", path.module))
  }

  identity {
    type = "SystemAssigned"
  }

  patch_mode            = var.patch_mode
  patch_assessment_mode = var.patch_mode == "AutomaticByPlatform" ? var.patch_mode : "ImageDefault"
  hotpatching_enabled   = var.hotpatching_enabled

}

resource "null_resource" "winrm_connection_test" {
  count = var.public_ip_sku == null ? 0 : 1

  depends_on = [
    azurerm_network_interface.nic,
    azurerm_public_ip.public_ip,
    azurerm_windows_virtual_machine.vm,
  ]

  triggers = {
    uuid = azurerm_windows_virtual_machine.vm.id
  }

  connection {
    type     = "winrm"
    host     = join("", azurerm_public_ip.public_ip[*].ip_address)
    port     = 5986
    https    = true
    user     = var.admin_username
    password = var.admin_password
    timeout  = "3m"

    # NOTE: if you're using a real certificate, rather than a self-signed one, you'll want this set to `false`/to remove this.
    insecure = true
  }

  provisioner "remote-exec" {
    inline = [
      "cd C:\\claranet",
      "dir",
    ]
  }
}

module "vm_os_disk_tagging" {
  source  = "claranet/tagging/azurerm"
  version = "4.0.2"

  nb_resources = var.os_disk_tagging_enabled ? 1 : 0
  resource_ids = [data.azurerm_managed_disk.vm_os_disk.id]
  behavior     = "merge" # Must be "merge" or "overwrite"

  tags = merge(local.default_tags, var.extra_tags, var.os_disk_extra_tags)
}

resource "azurerm_managed_disk" "disk" {
  for_each = var.storage_data_disk_config

  location            = var.location
  resource_group_name = var.resource_group_name

  name = lookup(each.value, "name", var.use_caf_naming ? azurecaf_name.disk[each.key].result : "${local.vm_name}-datadisk${each.key}")

  zone                 = var.zone_id
  storage_account_type = lookup(each.value, "storage_account_type", "Standard_LRS")

  create_option = lookup(each.value, "create_option", "Empty")
  disk_size_gb  = lookup(each.value, "disk_size_gb", null)

  tags = merge(local.default_tags, var.extra_tags, lookup(each.value, "extra_tags", {}))
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attach" {
  for_each = var.storage_data_disk_config

  managed_disk_id    = azurerm_managed_disk.disk[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id

  lun     = lookup(each.value, "lun")
  caching = lookup(each.value, "caching", "ReadWrite")
}

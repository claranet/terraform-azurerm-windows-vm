resource "azurerm_virtual_machine" "vm" {
  name                  = local.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = var.vm_size
  license_type          = var.license_type

  tags = merge(local.default_tags, var.extra_tags)

  delete_os_disk_on_termination    = var.delete_os_disk_on_termination
  delete_data_disks_on_termination = var.delete_data_disks_on_termination

  storage_image_reference {
    id        = lookup(var.vm_image, "id", null)
    offer     = lookup(var.vm_image, "offer", null)
    publisher = lookup(var.vm_image, "publisher", null)
    sku       = lookup(var.vm_image, "sku", null)
    version   = lookup(var.vm_image, "version", null)
  }

  availability_set_id = var.availability_set_id

  zones = var.zone_id == null ? null : [var.zone_id]

  boot_diagnostics {
    enabled     = true
    storage_uri = "https://${var.diagnostics_storage_account_name}.blob.core.windows.net"
  }

  storage_os_disk {
    name              = "${local.vm_name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = local.vm_name
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data    = local.custom_data_content
  }

  os_profile_secrets {
    source_vault_id = var.key_vault_id

    vault_certificates {
      certificate_url   = azurerm_key_vault_certificate.winrm_certificate.secret_id
      certificate_store = "My"
    }
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true

    # Auto-Login's required to configure WinRM
    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "AutoLogon"
      content      = "<AutoLogon><Password><Value>${local.admin_password_encoded}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.admin_username}</Username></AutoLogon>"
    }

    # Unattend config is to enable basic auth in WinRM, required for the provisioner stage.
    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "FirstLogonCommands"
      content      = file(format("%s/files/FirstLogonCommands.xml", path.module))
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "null_resource" "winrm_connection_test" {
  count = var.public_ip_sku == null ? 0 : 1

  depends_on = [
    azurerm_network_interface.nic,
    azurerm_public_ip.public_ip,
    azurerm_virtual_machine.vm,
  ]

  triggers = {
    uuid = azurerm_virtual_machine.vm.id
  }

  connection {
    type     = "winrm"
    host     = join("", azurerm_public_ip.public_ip.*.ip_address)
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

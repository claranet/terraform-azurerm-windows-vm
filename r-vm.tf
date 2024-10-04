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
    for_each = var.vm_image_id == null ? ["enabled"] : []
    content {
      offer     = lookup(var.vm_image, "offer", null)
      publisher = lookup(var.vm_image, "publisher", null)
      sku       = lookup(var.vm_image, "sku", null)
      version   = lookup(var.vm_image, "version", null)
    }
  }

  dynamic "plan" {
    for_each = var.vm_plan[*]
    content {
      name      = var.vm_plan.name
      product   = var.vm_plan.product
      publisher = var.vm_plan.publisher
    }
  }

  availability_set_id = var.availability_set_id

  zone = var.zone_id

  boot_diagnostics {
    storage_account_uri = "https://${var.diagnostics_storage_account_name}.blob.core.windows.net"
  }

  os_disk {
    name                 = local.vm_os_disk_name
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }

  encryption_at_host_enabled = var.encryption_at_host_enabled

  dynamic "identity" {
    for_each = local.identity[*]
    content {
      type         = local.identity.type
      identity_ids = local.identity.identity_ids
    }
  }

  computer_name  = local.vm_hostname
  admin_username = var.admin_username
  admin_password = var.admin_password

  custom_data = base64encode(local.custom_data_content)
  user_data   = var.user_data

  dynamic "secret" {
    for_each = var.key_vault_id[*]
    content {
      key_vault_id = var.key_vault_id

      certificate {
        url   = one(azurerm_key_vault_certificate.winrm_certificate[*].secret_id)
        store = "My"
      }
    }
  }

  dynamic "additional_unattend_content" {
    for_each = var.key_vault_id != null ? local.additional_unattend_content : {}

    content {
      setting = additional_unattend_content.key
      content = additional_unattend_content.value
    }
  }

  priority        = var.spot_instance ? "Spot" : "Regular"
  max_bid_price   = var.spot_instance ? var.spot_instance_max_bid_price : null
  eviction_policy = var.spot_instance ? var.spot_instance_eviction_policy : null

  provision_vm_agent       = true
  enable_automatic_updates = true

  patch_mode                                             = var.patch_mode
  patch_assessment_mode                                  = var.patch_mode == "AutomaticByPlatform" ? var.patch_mode : "ImageDefault"
  hotpatching_enabled                                    = var.hotpatching_enabled
  bypass_platform_safety_checks_on_user_schedule_enabled = var.patch_mode == "AutomaticByPlatform"
  reboot_setting                                         = var.patch_mode == "AutomaticByPlatform" ? var.patching_reboot_setting : null
}

resource "null_resource" "winrm_connection_test" {
  count = (var.public_ip_sku == null || var.key_vault_id == null) ? 0 : 1

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
  version = "6.0.2"

  nb_resources = var.os_disk_tagging_enabled ? 1 : 0
  resource_ids = [data.azurerm_managed_disk.vm_os_disk.id]
  behavior     = var.os_disk_overwrite_tags ? "overwrite" : "merge"

  tags = merge(local.default_tags, var.extra_tags, var.os_disk_extra_tags)
}

resource "azurerm_managed_disk" "disk" {
  for_each = var.storage_data_disk_config

  location            = var.location
  resource_group_name = var.resource_group_name

  name = coalesce(each.value.name, var.use_caf_naming ? data.azurecaf_name.disk[each.key].result : format("%s-datadisk%s", local.vm_name, each.key))

  zone                 = can(regex("_zrs$", lower(each.value.storage_account_type))) ? null : var.zone_id
  storage_account_type = each.value.storage_account_type
  create_option        = each.value.create_option
  disk_size_gb         = each.value.disk_size_gb
  source_resource_id   = contains(["Copy", "Restore"], each.value.create_option) ? each.value.source_resource_id : null

  tags = merge(local.default_tags, var.extra_tags, each.value.extra_tags)
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachment" {
  for_each = var.storage_data_disk_config

  managed_disk_id    = azurerm_managed_disk.disk[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id

  lun     = coalesce(each.value.lun, index(keys(var.storage_data_disk_config), each.key))
  caching = each.value.caching
}

# To be iso as linux-vm
moved {
  from = azurerm_virtual_machine_data_disk_attachment.disk_attach
  to   = azurerm_virtual_machine_data_disk_attachment.data_disk_attachment
}

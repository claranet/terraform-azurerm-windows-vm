resource "azurerm_key_vault_certificate" "winrm_certificate" {
  name         = "winrm-${local.vm_name}-cert"
  key_vault_id = var.key_vault_id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject            = "CN=${local.vm_name}"
      validity_in_months = var.certificate_validity_in_months
    }
  }
}

resource "azurerm_key_vault_access_policy" "vm" {
  key_vault_id = var.key_vault_id

  object_id = azurerm_windows_virtual_machine.vm.identity[0].principal_id
  tenant_id = data.azurerm_client_config.current.tenant_id

  secret_permissions = ["get", "list"]
}

resource "azurerm_virtual_machine_extension" "keyvault_certificates" {
  count = var.key_vault_certificates_names != [] ? 1 : 0

  name = "${azurerm_windows_virtual_machine.vm.name}-keyvaultextension"

  publisher                  = "Microsoft.Azure.KeyVault"
  type                       = "KeyVaultForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  virtual_machine_id = azurerm_windows_virtual_machine.vm.id

  settings = jsonencode({
    secretsManagementSettings : {
      pollingIntervalInS       = tostring(var.key_vault_certificates_polling_rate)
      certificateStoreName     = var.key_vault_certificates_store_name,
      certificateStoreLocation = "LocalMachine",
      requiredInitialSync      = true
      observedCertificates     = formatlist("https://%s.vault.azure.net/secrets/%s", local.key_vault_name, var.key_vault_certificates_names)
    }
  })

  depends_on = [azurerm_key_vault_access_policy.vm]
}

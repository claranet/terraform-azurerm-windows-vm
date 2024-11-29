resource "azurerm_key_vault_certificate" "main" {
  count = var.key_vault != null ? 1 : 0

  name = "winrm-${local.name}-cert"

  key_vault_id = var.key_vault.id

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
      subject            = "CN=${local.name}"
      validity_in_months = var.certificate_validity_in_months
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]
      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]
    }
  }
}

moved {
  from = azurerm_key_vault_certificate.winrm_certificate[0]
  to   = azurerm_key_vault_certificate.main[0]
}

resource "azurerm_key_vault_access_policy" "main" {
  count = var.key_vault != null ? 1 : 0

  key_vault_id = var.key_vault.id

  object_id = azurerm_windows_virtual_machine.main.identity[0].principal_id
  tenant_id = data.azurerm_client_config.current.tenant_id

  secret_permissions = ["Get", "List"]
}

moved {
  from = azurerm_key_vault_access_policy.vm[0]
  to   = azurerm_key_vault_access_policy.main[0]
}

resource "azurerm_virtual_machine_extension" "key_vault_certificates" {
  count = var.key_vault_certificates.names != null ? 1 : 0

  name = "${azurerm_windows_virtual_machine.main.name}-keyvaultextension"

  publisher            = "Microsoft.Azure.KeyVault"
  type                 = "KeyVaultForWindows"
  type_handler_version = "1.0"

  virtual_machine_id = azurerm_windows_virtual_machine.main.id

  auto_upgrade_minor_version = true

  settings = jsonencode({
    secretsManagementSettings = {
      pollingIntervalInS       = tostring(var.key_vault_certificates.polling_rate)
      certificateStoreName     = var.key_vault_certificates.store_name
      certificateStoreLocation = "LocalMachine"
      requiredInitialSync      = true
      observedCertificates     = formatlist("https://%s.vault.azure.net/secrets/%s", local.key_vault_name, var.key_vault_certificates.names)
    }
  })

  tags = merge(local.default_tags, var.extra_tags, var.extensions_extra_tags)

  depends_on = [
    azurerm_key_vault_access_policy.main,
  ]
}

moved {
  from = azurerm_virtual_machine_extension.keyvault_certificates[0]
  to   = azurerm_virtual_machine_extension.key_vault_certificates[0]
}

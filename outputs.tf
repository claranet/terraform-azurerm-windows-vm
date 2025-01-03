output "resource" {
  description = "Windows Virtual Machine resource object."
  value       = azurerm_windows_virtual_machine.main
}

output "resource_public_ip" {
  description = "Public IP resource object."
  value       = one(azurerm_public_ip.main[*])
}

output "resource_network_interface" {
  description = "Network interface resource object."
  value       = azurerm_network_interface.main
}

output "resource_key_vault_certificate" {
  description = "WinRM Key Vault certificate resource object."
  value       = one(azurerm_key_vault_certificate.main[*])
}

output "resource_maintenance_configuration_assignment" {
  description = "Maintenance configuration assignment resource object."
  value       = azurerm_maintenance_assignment_virtual_machine.main
}

output "id" {
  description = "ID of the Virtual Machine."
  value       = azurerm_windows_virtual_machine.main.id
}

output "name" {
  description = "Name of the Virtual Machine."
  value       = azurerm_windows_virtual_machine.main.name
}

output "hostname" {
  description = "Hostname of the Virtual Machine."
  value       = azurerm_windows_virtual_machine.main.computer_name
}

output "admin_username" {
  description = "Administrator username of the Virtual Machine."
  value       = azurerm_windows_virtual_machine.main.admin_username
}

output "admin_password" {
  description = "Administrator password of the Virtual Machine."
  value       = azurerm_windows_virtual_machine.main.admin_password
  sensitive   = true
}

output "identity_principal_id" {
  description = "Object ID of the Virtual Machine Managed Service Identity."
  value       = try(azurerm_windows_virtual_machine.main.identity[0].principal_id, null)
}

output "public_ip_id" {
  description = "Public IP ID of the Virtual Machine."
  value       = one(azurerm_public_ip.main[*].id)
}

output "public_ip_name" {
  description = "Public IP name of the Virtual Machine."
  value       = one(azurerm_public_ip.main[*].name)
}

output "public_domain_name_label" {
  description = "Public domain name of the Virtual Machine."
  value       = one(azurerm_public_ip.main[*].domain_name_label)
}

output "public_ip_address" {
  description = "Public IP address of the Virtual Machine."
  value       = one(azurerm_public_ip.main[*].ip_address)
}

output "nic_id" {
  description = "ID of the network interface attached to the Virtual Machine."
  value       = azurerm_network_interface.main.id
}

output "nic_name" {
  description = "Name of the network interface attached to the Virtual Machine."
  value       = azurerm_network_interface.main.name
}

output "nic_ip_configuration_name" {
  description = "Name of the IP configuration for the network interface attached to the Virtual Machine."
  value       = azurerm_network_interface.main.ip_configuration[0].name
}

output "private_ip_address" {
  description = "Private IP address of the Virtual Machine."
  value       = azurerm_network_interface.main.private_ip_address
}

output "winrm_key_vault_certificate_id" {
  description = "ID of the generated WinRM Key Vault certificate."
  value       = one(azurerm_key_vault_certificate.main[*].id)
}

output "winrm_key_vault_certificate_name" {
  description = "Name of the generated WinRM Key Vault certificate."
  value       = one(azurerm_key_vault_certificate.main[*].name)
}

output "winrm_key_vault_certificate_data" {
  description = "RAW Key Vault certificate data represented as a hexadecimal string."
  value       = one(azurerm_key_vault_certificate.main[*].certificate_data)
}

output "winrm_key_vault_certificate_thumbprint" {
  description = "X509 thumbprint of the Key Vault certificate represented as a hexadecimal string."
  value       = one(azurerm_key_vault_certificate.main[*].thumbprint)
}

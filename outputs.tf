output "vm_id" {
  description = "Id of the Virtual machine"
  value       = azurerm_windows_virtual_machine.vm.id
}

output "vm_name" {
  description = "Name of the Virtual machine"
  value       = azurerm_windows_virtual_machine.vm.name
}

output "vm_hostname" {
  description = "Hostname of the Virtual machine"
  value       = azurerm_windows_virtual_machine.vm.computer_name
}

output "vm_public_ip_address" {
  description = "Public IP address of the Virtual machine"
  value       = one(azurerm_public_ip.public_ip[*].ip_address)
}

output "vm_public_domain_name_label" {
  description = "Public DNS of the Virtual machine"
  value       = one(azurerm_public_ip.public_ip[*].domain_name_label)
}

output "vm_private_ip_address" {
  description = "Private IP address of the Virtual machine"
  value       = azurerm_network_interface.nic.private_ip_address
}

output "vm_winrm_certificate_key_vault_id" {
  description = "Id of the generated certificate in the input Key Vault"
  value       = azurerm_key_vault_certificate.winrm_certificate.id
}

output "vm_winrm_certificate_data" {
  description = "The raw Key Vault Certificate."
  value       = azurerm_key_vault_certificate.winrm_certificate.certificate_data
}

output "vm_winrm_certificate_thumbprint" {
  description = "The X509 Thumbprint of the Key Vault Certificate returned as hex string."
  value       = azurerm_key_vault_certificate.winrm_certificate.thumbprint
}

output "vm_nic_name" {
  description = "Name of the Network Interface Configuration attached to the Virtual Machine"
  value       = azurerm_network_interface.nic.name
}

output "vm_nic_id" {
  description = "ID of the Network Interface Configuration attached to the Virtual Machine"
  value       = azurerm_network_interface.nic.id
}

output "vm_nic_ip_configuration_name" {
  description = "Name of the IP Configuration for the Network Interface Configuration attached to the Virtual Machine"
  value       = local.ip_configuration_name
}

output "vm_admin_username" {
  description = "Windows Virtual Machine administrator account username"
  value       = var.admin_username
  sensitive   = true
}

output "vm_admin_password" {
  description = "Windows Virtual Machine administrator account password"
  value       = var.admin_password
  sensitive   = true
}

output "maintenance_configurations_assignments" {
  description = "Maintenance configurations assignments configurations."
  value       = azurerm_maintenance_assignment_virtual_machine.maintenance_configurations
}

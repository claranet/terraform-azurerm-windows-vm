output "vm_id" {
  value = "${azurerm_virtual_machine.vm.name}"
}

output "vm_name" {
  value = "${azurerm_virtual_machine.vm.name}"
}

output "vm_public_ip_address" {
  value = "${azurerm_public_ip.public_ip.ip_address}"
}

output "vm_private_ip_address" {
  value = "${azurerm_network_interface.nic.private_ip_address}"
}

output "vm_certificate_key_vault_id" {
  value = "${azurerm_key_vault_certificate.certificate.id}"
}

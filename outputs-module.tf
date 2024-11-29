output "terraform_module" {
  description = "Information about this Terraform module."
  value = {
    name       = "windows-vm"
    provider   = "azurerm"
    maintainer = "claranet"
  }
}

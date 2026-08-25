module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "~> 9.0"

  azure_region = var.location
}

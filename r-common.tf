module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "~> 6.1.0"

  azure_region = var.location
}

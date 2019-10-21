resource "azurerm_public_ip" "public_ip" {
  name                = "${local.vm_name}-pubip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  domain_name_label   = coalesce(var.custom_dns_label, local.vm_name)
  sku                 = var.public_ip_sku

  tags = merge(local.default_tags, var.extra_tags)
}

resource "azurerm_network_interface" "nic" {
  name                = "${local.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "configuration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  tags = merge(local.default_tags, var.extra_tags)
}

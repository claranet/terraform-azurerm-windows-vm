resource "azurerm_public_ip" "public_ip" {
  count = var.public_ip_sku == null ? 0 : 1

  name                = local.vm_pub_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  domain_name_label   = coalesce(var.custom_dns_label, local.vm_name)
  sku                 = var.public_ip_sku
  zones               = var.public_ip_zones

  tags = merge(local.default_tags, var.extra_tags, var.public_ip_extra_tags)
}

resource "azurerm_network_interface" "nic" {
  name                = local.vm_nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  enable_accelerated_networking = var.nic_enable_accelerated_networking

  ip_configuration {
    name                          = local.ip_configuration_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.static_private_ip == null ? "Dynamic" : "Static"
    private_ip_address            = var.static_private_ip
    public_ip_address_id          = var.public_ip_sku == null ? null : join("", azurerm_public_ip.public_ip[*].id)
  }

  tags = merge(local.default_tags, var.extra_tags, var.nic_extra_tags)
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_association" {
  count = var.nic_nsg_id == null ? 0 : 1

  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = var.nic_nsg_id
}

resource "azurerm_network_interface_backend_address_pool_association" "lb_pool_association" {
  count = var.attach_load_balancer ? 1 : 0

  backend_address_pool_id = var.load_balancer_backend_pool_id
  ip_configuration_name   = local.ip_configuration_name
  network_interface_id    = azurerm_network_interface.nic.id
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "appgw_pool_association" {
  count = var.attach_application_gateway ? 1 : 0

  backend_address_pool_id = var.application_gateway_backend_pool_id
  ip_configuration_name   = local.ip_configuration_name
  network_interface_id    = azurerm_network_interface.nic.id
}

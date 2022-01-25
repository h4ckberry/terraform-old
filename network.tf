
resource "azurerm_virtual_network" "vn_enk_dev" {
  name                = "vn-${var.user}-${var.env}"
  location            = azurerm_resource_group.rg_enk_dev.location
  resource_group_name = azurerm_resource_group.rg_enk_dev.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
  tags                = var.tags
}

resource "azurerm_subnet" "sn_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg_enk_dev.name
  virtual_network_name = azurerm_virtual_network.vn_enk_dev.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "sn_private" {
  name                 = "sn-private"
  resource_group_name  = azurerm_resource_group.rg_enk_dev.name
  virtual_network_name = azurerm_virtual_network.vn_enk_dev.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "nsg_association_bastion" {
  subnet_id                 = azurerm_subnet.sn_bastion.id
  network_security_group_id = azurerm_network_security_group.nsg_bastion.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_association_private" {
  subnet_id                 = azurerm_subnet.sn_private.id
  network_security_group_id = azurerm_network_security_group.nsg_private.id
}

resource "azurerm_public_ip" "pip_bastion" {
  name                = "pip-bas-${var.user}-${var.env}"
  location            = azurerm_resource_group.rg_enk_dev.location
  resource_group_name = azurerm_resource_group.rg_enk_dev.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = "bas-${var.user}-${var.env}"
  location            = azurerm_resource_group.rg_enk_dev.location
  resource_group_name = azurerm_resource_group.rg_enk_dev.name

  ip_configuration {
    name                 = "vm_ip_configuration"
    subnet_id            = azurerm_subnet.sn_bastion.id
    public_ip_address_id = azurerm_public_ip.pip_bastion.id
  }
}



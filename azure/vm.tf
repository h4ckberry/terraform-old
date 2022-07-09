resource "azurerm_network_interface" "nic_mgmt" {
    name                      = "nic-mgmt"
    location                  = azurerm_resource_group.rg_enk_dev.location
    resource_group_name       = azurerm_resource_group.rg_enk_dev.name

    ip_configuration {
        name                          = "NicConfiguration"
        subnet_id                     = azurerm_subnet.sn_private.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_linux_virtual_machine" "vm_mgmt" {
    name                  = "vm-mgmt"
    location              = azurerm_resource_group.rg_enk_dev.location
    resource_group_name   = azurerm_resource_group.rg_enk_dev.name
    network_interface_ids = [azurerm_network_interface.nic_mgmt.id]
    size                  = "Standard_B4s"

    os_disk {
        name              = "mgmtOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-focal"
        sku       = "20_04-lts-gen2"
        version   = "latest"
    }

    computer_name  = "mgmt"
    admin_username = "enkuser"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "enkuser"
        public_key     = tls_private_key.mgmt_ssh.public_key_openssh
    }
}

resource "tls_private_key" "mgmt_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" {
    value = tls_private_key.mgmt_ssh.private_key_pem
    sensitive = true
}

resource "local_file" "private_key_pem" {
  filename = "./bas_ssh_key.pem"
  content  = tls_private_key.mgmt_ssh.private_key_pem
  provisioner "local-exec" {
    command = "chmod 600 ./bas_ssh_key.pem"
  }
}
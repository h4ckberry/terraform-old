resource "azurerm_network_interface" "nic_win" {
  name                = "nic-win"
  resource_group_name = azurerm_resource_group.rg_enk_dev.name
  location            = azurerm_resource_group.rg_enk_dev.location

  ip_configuration {
    name                          = "WinNicConfig"
    subnet_id                     = azurerm_subnet.sn_private.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm_win" {
  name                  = "vm-windows"
  resource_group_name   = azurerm_resource_group.rg_enk_dev.name
  location              = azurerm_resource_group.rg_enk_dev.location
  size                  = "Standard_B4ms"
  network_interface_ids = [azurerm_network_interface.nic_win.id]

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"
  }

  os_disk {
    name                 = "winOsDisk"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  computer_name  = "iswin"
  admin_username = "i4admin"
  admin_password = "qwezxcasd9!"
  #   disable_password_authentication = true
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "schedule_shutdown" {
  virtual_machine_id = azurerm_windows_virtual_machine.vm_win.id
  location           = azurerm_resource_group.rg_enk_dev.location
  enabled            = true

  daily_recurrence_time = "1800"
  timezone              = "Tokyo Standard Time"

  notification_settings {
    enabled = false
    # time_in_minutes = "60"
    # webhook_url     = "https://sample-webhook-url.example.com"
  }
}

resource "azurerm_virtual_machine_extension" "custom_script_win" {
  name                 = "InstallWsl2"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm_win.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  protected_settings = <<SETTINGS
    {
      "commandToExecute": "powershell -command \\\"wsl --install\\\""
    }
  SETTINGS
}

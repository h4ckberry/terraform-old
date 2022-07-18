# Example of terraform.tfvars

```
tags = {
  user = ""
  env  = ""
}

vnet = {
  address_space = ["x.x.x.x/x"]
  dns_servers   = ["y.y.y.y/y", "z.z.z.z/z"]
}

bastion = {
  pip = {
    allocation_method = "Static"
    sku               = "Standard"
  }
  host = {
    sku               = "Standard"
    tunneling_enabled = true
  }
}

vm = {
  linux = {
    size = "Standard_B4ms"
    image = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-focal"
      sku       = "20_04-lts-gen2"
      version   = "latest"
    }
  }
  windows = {
    count          = 0 # 0 or 1
    admin_password = ""
    size           = "Standard_B4ms"
    image = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2022-datacenter"
      version   = "latest"
    }
  }
}
```


provider "azurerm" {

  client_id       = "97d9be21-2185-423a-b450-c1cec63b1e4b"
  client_secret   = "QvY8Q~nYgkL2yj3jiiRd0EtfYfulvcnlvgTLAcZf"
  tenant_id       = "84f1e4ea-8554-43e1-8709-f0b8589ea118"
  subscription_id = "0cfe2870-d256-4119-b0a3-16293ac11bdc"
  features {}
  skip_provider_registration = true
}

/*resource "azurerm_resource_group" "Sandbox_RG" {
  name     = "1-955a11d0-playground-sandbox"
  location = "South Central US"
}*/

resource "azurerm_virtual_network" "Sandbox_Vnet" {
  name                = "Sandbox_Vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "South Central US"
  resource_group_name = "1-955a11d0-playground-sandbox"
}

resource "azurerm_subnet" "Sandbox_sub" {
  name                 = "Sandbox-subnet"
  resource_group_name  = "1-955a11d0-playground-sandbox"
  virtual_network_name = azurerm_virtual_network.Sandbox_Vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "Sandbox_pub_IP" {
  name                = "Sandbox-public-ip"
  location            = "South Central US"
  resource_group_name = "1-955a11d0-playground-sandbox"
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "Sandbox-nic" {
  name                = "Sandbox-nic"
  location            = "South Central US"
  resource_group_name = "1-955a11d0-playground-sandbox"
  ip_configuration {
    name                          = "Sandbox-nic-configuration"
    subnet_id                     = azurerm_subnet.Sandbox_sub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.Sandbox_pub_IP.id
  }
}

resource "azurerm_linux_virtual_machine" "Sandbox_VM" {
  name                = "SandboxVM"
  location            = "South Central US"
  resource_group_name = "1-955a11d0-playground-sandbox"
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.Sandbox-nic.id,
  ]
  admin_password                  = "Proximus#18"
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

provider "azurerm" {

  client_id       = "1347d1a8-da16-48df-8f4d-21fe8e406d19"
  client_secret   = "F6N8Q~T1dmgm2-iGKYHbd0v03mRGIUIhLJF6qckt"
  tenant_id       = "84f1e4ea-8554-43e1-8709-f0b8589ea118"
  subscription_id = "80ea84e8-afce-4851-928a-9e2219724c69"
  features {}
  skip_provider_registration = true
}

/*resource "azurerm_resource_group" "NJ_RG" {
  name     = "1-5cb7191f-playground-sandbox"
  location = "South Central US"
}*/

resource "azurerm_virtual_network" "NJ_Vnet" {
  name                = "NJ_Vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "South Central US"
  resource_group_name = "1-5cb7191f-playground-sandbox"
}

resource "azurerm_subnet" "NJ_sub" {
  name                 = "NJ_subnet"
  resource_group_name  = "1-5cb7191f-playground-sandbox"
  virtual_network_name = azurerm_virtual_network.NJ_Vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "NJ_pub_IP" {
  name                = "NJ_public-ip"
  location            = "South Central US"
  resource_group_name = "1-5cb7191f-playground-sandbox"
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "NJ_nic" {
  name                = "NJ_nic"
  location            = "South Central US"
  resource_group_name = "1-5cb7191f-playground-sandbox"
  ip_configuration {
    name                          = "NJ_nic-configuration"
    subnet_id                     = azurerm_subnet.NJ_sub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.NJ_pub_IP.id
  }
}

resource "azurerm_linux_virtual_machine" "NJ_VM" {
  name                = "NJVM"
  location            = "South Central US"
  resource_group_name = "1-5cb7191f-playground-sandbox"
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.NJ_nic.id,
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
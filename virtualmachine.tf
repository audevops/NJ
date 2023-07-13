resource "azurerm_virtual_network" "DB_Vnet" {
  name                = "DB_Vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "DB_sub" {
  name                 = "DB-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.DB_Vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "DB_pub_IP_1" {
  name                = "DB-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "MON_pub_IP_4" {
  name                = "MON-public-ip-4"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "DB-nic-1" {
  name                = "DB-nic_1"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "DB-nic-configuration"
    subnet_id                     = azurerm_subnet.DB_sub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.DB_pub_IP_1.id
  }
}

resource "azurerm_network_interface" "MON-nic" {
  name                = "MON-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "MON-nic-configuration"
    subnet_id                     = azurerm_subnet.DB_sub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.MON_pub_IP_4.id
  }
}
resource "azurerm_linux_virtual_machine" "DB_VM_1" {
  name                = "DBVM1"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.DB-nic-1.id,
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

resource "azurerm_linux_virtual_machine" "MON1" {
  name                = "MON1"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.MON-nic.id,
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
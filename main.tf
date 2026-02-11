#resource block  #resource type   #reference name - terraform ko samajhne ke liye 
resource "azurerm_resource_group" "rg" {
  name     = "restart-rg"  #Name of the resource group 
  location = "West Europe" #Kis region me ye rg banega 
}


#resource block  #resource type   #reference name - terraform ko samajhne ke liye 
resource "azurerm_virtual_network" "vnet" {
  name                = "restart-vnet"   #Name of the Virtual Netwrok
  address_space       = ["10.0.0.0/16"]  #IP Range of this VNET
  location            = azurerm_resource_group.rg.location   #Location on Resource Group becuase VNET and RG should be on same location 
  resource_group_name = azurerm_resource_group.rg.name       #Name of Resource Group, because RG will hold this resource VNET
}

#resource block  #resource type   #reference name - terraform ko samajhne ke liye 
resource "azurerm_subnet" "subnet" {
  name                 = "restart-subnet" #Name of the Subnet
  resource_group_name  = azurerm_resource_group.rg.name      #Name of Resource Group, because RG will hold this resource Subnet
  virtual_network_name = azurerm_virtual_network.vnet.name   #Name of Virtual Network, because Subnet will be created in this Virtual Network
  address_prefixes     = ["10.0.2.0/24"] #IP range of subnet but it should be under the IP Range of VNET
}

#resource block  #resource type   #reference name - terraform ko samajhne ke liye 
resource "azurerm_network_interface" "nic" {
  name                = "restart-nic"                       #Name of the NIC
  location            = azurerm_resource_group.rg.location  #Location of Resource Group, because RG will hold this resource NIC
  resource_group_name = azurerm_resource_group.rg.name      #Name of Resource Group, because RG will hold this resource NIC

  ip_configuration {
    name                          = "internal"                #IP Config ka naame - kuch bhi rakh sakte hai
    subnet_id                     = azurerm_subnet.subnet.id  #Imporant - Meaning is NIC ko kis Subnet pe attach karna hai
    private_ip_address_allocation = "Dynamic"                 #Azure automatically private IP assign karega but agar hume Static IP assign karna hai to yaha "Static" Likha hoga aur manually assign karna hoga
    public_ip_address_id =  azurerm_public_ip.pip.id          #Ye optional argument coz hume public ip ko yaha define karna hai jo is NIC pe lagega aur VM ko public IP de dega
  }
}

resource "azurerm_public_ip" "pip" {  # Ye block isiliye coz hume public ip use karna hai
  name                = "restart-pip" 
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static" #"Dynamic" bhi use kar sakte hai but VM restart pe change ho jaega
  #Isiliye Production me Static use karte hai
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "restart-machine"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_D2s_v3"
  admin_username                  = "adminuser"
  admin_password                  = "password@123"  # Ye isiliye coz humne username and password chiye 
  disable_password_authentication = false   # Ye mandotory hota hai jab hum via admin_password use karte hai
  network_interface_ids = [
  azurerm_network_interface.nic.id]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
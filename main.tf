# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "azurerm" {
  features {}
  subscription_id = "var.ARM_SUBSCRIPTION_ID"
  default_tags {
        tags = {
          Project = "Udacity-deployment-project"
            }
      }
}

# Virtual network
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/24"]
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
}

#network security group
resource "azurerm_network_security_group" "project_NSG" {
  name                = "${var.prefix}-NSG"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  
  security_rule {
       name                        = "allow-subnet-traffic"
       priority                     = 100
       direction                   = "Inbound"
       access                      = "Allow"
       protocol                    = "*" # Allow any protocol
       source_port_range           = "*"  # Allow any port range
       source_address_prefix       = "VirtualNetwork" # Allow from the subnet
       destination_port_range      = "*"  # Allow any port range
       destination_address_prefix = "VirtualNetwork" # Allow traffic to the subnet
     
   }
   
   security_rule {
       name                        = "deny-access-from-internet"
       priority                    = 120
       direction                   = "Inbound"
       access                      = "Deny"
       protocol                    = "*" # Deny any protocol
       source_port_range           = "*"  # Deny any port range
       source_address_prefix       = "Internet" # from source
       destination_port_range      = "*" 
       destination_address_prefix = "VirtualNetwork"
     
   }
}

#subnet
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = "${var.resource_group}"
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
  network_security_group_id = azurerm_network_security_group.project_NSG.id
}

#network interface
resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  resource_group_name = "${var.resource_group}"
  location            = "${var.location}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb" "load_balancer" {
  name                = "${var.prefix}-lb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"

  frontend_ip_configuration {
    name                 = "primary"
    public_ip_address_id = azurerm_public_ip.load_balancer.id
  }
}

resource "azurerm_lb_backend_address_pool" "bknd_pool" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "${var.prefix}-bknd-address-pool-lb"
}


resource "azurerm_network_interface_backend_address_pool_association" "addresspool_assn" {
  network_interface_id    = azurerm_network_interface.main.id
  ip_configuration_name   = "${var.prefix}-addresspool-assn"
  backend_address_pool_id = azurerm_lb_backend_address_pool.bknd_pool.id
}

resource "azurerm_availability_set" "availability_set" {
  name                = "${var.prefix}-aset"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"

}

data "azurerm_image" "packer-image" {
  name                = var.packer_image_name
  resource_group_name = "${var.resource_group}"
}

resource "azurerm_linux_virtual_machine" "main" {
  count                           = "${var.vm_count}"
  name                            = "${var.prefix}-vm-${count.index}"
  resource_group_name             = "${var.resource_group}"
  location                        = "${var.location}"
  size                            = "Standard_D2s_v3"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main[count.index].id,
  ]

storage_image_reference {
    id= data.azurerm_image.packer-image.id
}
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  
  resource "azurerm_managed_disk" "source" {
  name                 = "${var.prefix}-md1"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"
    }
}

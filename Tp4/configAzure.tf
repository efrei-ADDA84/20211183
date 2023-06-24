terraform {
    required_providers {
        azurerm = {
        source  = "hashicorp/azurerm"
        version = "=3.0.0"
        }
    }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
    features {}
    subscription_id = "765266c6-9a23-4638-af32-dd1e32613047"
}

data "azurerm_subnet" "subnet" {
    name                 = "internal"  
    virtual_network_name = "network-tp4"
    resource_group_name  = "ADDA84-CTP"
}

# Create public IPs
resource "azurerm_public_ip" "public_ip" {
    name                = "public-ip-maroua"
    location            = "francecentral"
    resource_group_name = data.azurerm_subnet.subnet.resource_group_name
    allocation_method   = "Dynamic"
}

# Create network interface
resource "azurerm_network_interface" "network_interface" {
    name                = "network_interface_maroua"
    location            = "francecentral"
    resource_group_name = data.azurerm_subnet.subnet.resource_group_name

    ip_configuration {
        name                          = "ipconfig"
        subnet_id                     = data.azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.public_ip.id
    }
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "virtual_machine" {
    name                  = "devops-20211183"
    location              = "francecentral"
    resource_group_name   = data.azurerm_subnet.subnet.resource_group_name
    network_interface_ids = [azurerm_network_interface.network_interface.id]
    size                  = "Standard_D2s_v3"

    os_disk {
        name                 = "osdisk-maroua-20211183"
        caching              = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04-LTS"
        version   = "latest"
    }

    computer_name                   = "devops-20211183"
    admin_username                  = "devops"
    disable_password_authentication = true

    admin_ssh_key {
        username   = "devops"
        public_key = tls_private_key.example_ssh.public_key_openssh
    }
}

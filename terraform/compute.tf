/*
===============================================================================
Secure Azure Foundation – Compute Configuration
-------------------------------------------------------------------------------
This file provisions the baseline Linux compute instance with secure defaults.

Security Rationale:
- VM is deployed without a public IP (private-by-default)
- SSH key authentication only (password authentication disabled)
- NIC is placed in the private subnet to reduce exposure
===============================================================================
*/

###############################################################################
# Network Interface (Private Subnet Only)
###############################################################################

resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-${var.vm_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # No public IP is attached. Access is intended via Bastion or private connectivity.
  ip_configuration {
    name                          = "ipconfig-private"
    subnet_id                     = azurerm_subnet.private.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "secure-foundation"
    component   = "compute"
  }
}

###############################################################################
# Linux Virtual Machine (No Public IP)
###############################################################################

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  size = var.vm_size

  admin_username                  = var.admin_username
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Ubuntu 22.04 LTS (Jammy) is a stable baseline OS commonly used in enterprise environments.
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  tags = {
    environment = "secure-foundation"
    component   = "compute"
  }
}

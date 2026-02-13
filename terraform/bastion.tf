/*
===============================================================================
Secure Azure Foundation – Bastion Configuration
-------------------------------------------------------------------------------
This file provisions Azure Bastion to enable secure administrative access
to virtual machines without exposing them via public IP addresses.

Security Rationale:
- Eliminates direct SSH exposure to the internet
- Enables browser-based secure access
- Reduces attack surface
- Supports zero-public-VM architecture
===============================================================================
*/

###############################################################################
# Public IP for Azure Bastion
###############################################################################

resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "pip-bastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "secure-foundation"
    component   = "bastion"
  }
}

###############################################################################
# Azure Bastion Host
###############################################################################

resource "azurerm_bastion_host" "bastion_host" {
  name                = "bas-secure-foundation"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Basic SKU is sufficient for controlled lab environments.
  # Production environments may require Standard for advanced features.
  sku = "Basic"

  ip_configuration {
    name                 = "bastion-ipconfig"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }

  tags = {
    environment = "secure-foundation"
    component   = "bastion"
  }
}

/*
===============================================================================
Secure Azure Foundation – Azure Bastion
-------------------------------------------------------------------------------
Azure Bastion provides secure administrative access to private VMs without
exposing SSH/RDP to the public internet.

Design Intent:
- No public IP on the VM
- Admin access occurs through Bastion over TLS (via the Azure portal)
- Bastion requires:
  - A dedicated subnet named "AzureBastionSubnet"
  - A Standard, Static Public IP
===============================================================================
*/

resource "azurerm_public_ip" "bastion_pip" {
  name                = "pip-bastion-secure-foundation"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  allocation_method = "Static"
  sku               = "Standard"

  tags = {
    environment = "secure-baseline"
    managed_by  = "terraform"
  }
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bas-secure-foundation"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  /*
    Basic is acceptable for labs.
    Standard adds additional capabilities and scaling features.
  */
  sku = "Basic"

  ip_configuration {
    name                 = "bastion-ipconfig"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }

  tags = {
    environment = "secure-baseline"
    managed_by  = "terraform"
  }
}

/*
===============================================================================
Secure Azure Foundation – Networking
-------------------------------------------------------------------------------
Defines the network boundary and egress model for the baseline environment.

Components:
- Virtual Network (VNet): private address space boundary
- Public Subnet: reserved for controlled ingress patterns (kept locked down)
- Private Subnet: hosts private workloads (VM resides here)
- Azure Bastion Subnet: dedicated subnet required for Bastion
- NAT Gateway: outbound internet for private subnet without inbound exposure
===============================================================================
*/

###############################################################################
# Virtual Network
###############################################################################

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-secure-foundation"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet_cidr]

  tags = {
    environment = "secure-baseline"
    managed_by  = "terraform"
    component   = "network"
  }
}

###############################################################################
# Subnets
###############################################################################

resource "azurerm_subnet" "public" {
  name                 = "snet-public"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.public_subnet_cidr]
}

resource "azurerm_subnet" "private" {
  name                 = "snet-private"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.private_subnet_cidr]
}

# Required dedicated subnet name for Azure Bastion
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.bastion_subnet_cidr]
}

###############################################################################
# NAT Gateway (Outbound for Private Subnet)
###############################################################################

resource "azurerm_public_ip" "nat_pip" {
  name                = "pip-nat-secure-foundation"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "secure-baseline"
    managed_by  = "terraform"
    component   = "network"
  }
}

resource "azurerm_nat_gateway" "nat" {
  name                = "nat-secure-foundation"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard"

  tags = {
    environment = "secure-baseline"
    managed_by  = "terraform"
    component   = "network"
  }
}

resource "azurerm_nat_gateway_public_ip_association" "nat_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat_pip.id
}

resource "azurerm_subnet_nat_gateway_association" "private_nat" {
  subnet_id      = azurerm_subnet.private.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}

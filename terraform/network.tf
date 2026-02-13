/*
===============================================================================
Secure Azure Foundation – Network Configuration
-------------------------------------------------------------------------------
This file provisions the core network baseline:

- Virtual Network (VNet) as the private network boundary
- Public and Private subnets for segmentation
- Azure Bastion subnet for secure administrative access
- NAT Gateway for controlled outbound internet access from private subnet

Security Rationale:
- Segmentation reduces blast radius and limits lateral movement
- Private workloads remain non-addressable from the public internet
- NAT provides outbound access without assigning public IPs to VMs
===============================================================================
*/

###############################################################################
# Virtual Network
###############################################################################

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-secure-foundation"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  address_space = [var.vnet_cidr]

  tags = {
    environment = "secure-foundation"
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

  address_prefixes = [var.public_subnet_cidr]
}

resource "azurerm_subnet" "private" {
  name                 = "snet-private"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = [var.private_subnet_cidr]
}

resource "azurerm_subnet" "bastion" {
  # Azure requires this subnet name for Bastion.
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = [var.bastion_subnet_cidr]
}

###############################################################################
# NAT Gateway (Outbound-only internet access for private subnet)
###############################################################################

resource "azurerm_public_ip" "nat_public_ip" {
  name                = "pip-nat-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  allocation_method = "Static"
  sku               = "Standard"

  tags = {
    environment = "secure-foundation"
    component   = "nat"
  }
}

resource "azurerm_nat_gateway" "nat_gateway" {
  name                = "nat-secure-foundation"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku_name = "Standard"

  tags = {
    environment = "secure-foundation"
    component   = "nat"
  }
}

resource "azurerm_nat_gateway_public_ip_association" "nat_public_ip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_public_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "private_subnet_nat_assoc" {
  subnet_id      = azurerm_subnet.private.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

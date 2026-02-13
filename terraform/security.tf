/*
===============================================================================
Secure Azure Foundation – Network Security Controls
-------------------------------------------------------------------------------
Defines Network Security Groups (NSGs) and subnet associations for the secure
foundation.

Security Posture:
- Explicitly deny inbound traffic from the Internet (defense-in-depth)
- Private subnet does not permit inbound administrative access from the public
- Outbound is allowed (egress is handled via NAT Gateway for the private subnet)

Rationale:
Azure provides default system rules. Explicit deny rules reduce the risk of
future accidental exposure caused by permissive rules added later.
===============================================================================
*/

###############################################################################
# Network Security Groups (NSGs)
###############################################################################

resource "azurerm_network_security_group" "public" {
  name                = "nsg-public-secure-foundation"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = "secure-baseline"
    managed_by  = "terraform"
    component   = "network-security"
    subnet      = "public"
  }
}

resource "azurerm_network_security_group" "private" {
  name                = "nsg-private-secure-foundation"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = "secure-baseline"
    managed_by  = "terraform"
    component   = "network-security"
    subnet      = "private"
  }
}

###############################################################################
# Subnet Associations (Subnet-Level Enforcement)
###############################################################################

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.public.id
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.private.id
}

###############################################################################
# Inbound Rules (Explicit Deny from Internet)
###############################################################################

resource "azurerm_network_security_rule" "public_deny_internet_inbound" {
  name                        = "deny-internet-inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.public.name
}

resource "azurerm_network_security_rule" "private_deny_internet_inbound" {
  name                        = "deny-internet-inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.private.name
}

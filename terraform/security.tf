/*
===============================================================================
Secure Azure Foundation – Security Controls
-------------------------------------------------------------------------------
This file defines network security boundaries for the secure foundation.

Scope:
- Network Security Groups (NSGs) for public and private subnets
- Least-privilege inbound posture (deny internet inbound explicitly)

Note:
Monitoring resources are currently included here for simplicity but should be
moved to a dedicated monitoring/logging file (e.g., monitoring.tf) in a
production repository.
===============================================================================
*/

###############################################################################
# Network Security Groups (NSGs)
###############################################################################

resource "azurerm_network_security_group" "public" {
  name                = "nsg-public"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = "secure-foundation"
    component   = "nsg"
    subnet      = "public"
  }
}

resource "azurerm_network_security_group" "private" {
  name                = "nsg-private"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = "secure-foundation"
    component   = "nsg"
    subnet      = "private"
  }
}

###############################################################################
# NSG Associations (Subnet-Level Enforcement)
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
  name                        = "deny-internet-inbound-public"
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
  name                        = "deny-internet-inbound-private"
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

###############################################################################
# Logging Baseline (Log Analytics Workspace)
###############################################################################

resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-secure-foundation"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku               = "PerGB2018"
  retention_in_days = 30

  tags = {
    environment = "secure-foundation"
    component   = "logging"
  }
}

###############################################################################
# Azure Monitor Agent (Linux VM Extension)
###############################################################################

resource "azurerm_virtual_machine_extension" "ama" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.9"
  auto_upgrade_minor_version = true

  tags = {
    environment = "secure-foundation"
    component   = "monitoring"
  }
}

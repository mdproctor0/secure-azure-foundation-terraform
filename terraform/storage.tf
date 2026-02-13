/*
===============================================================================
Secure Azure Foundation – Storage Configuration
-------------------------------------------------------------------------------
This file provisions a hardened Azure Storage Account.

Security Objectives:
- Prevent anonymous public access
- Enforce HTTPS-only traffic
- Require minimum TLS 1.2
- Disable public blob access
- Align with secure-by-default cloud principles

Storage is a frequent breach vector in Azure environments due to:
- Public containers
- Misconfigured access policies
- Weak transport enforcement

This configuration reduces those risks.
===============================================================================
*/

resource "azurerm_storage_account" "secure" {
  name                     = "stsecurefoundation${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  allow_blob_public_access        = false
  public_network_access_enabled   = true
  enable_https_traffic_only       = true

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "secure-baseline"
    managed_by  = "terraform"
  }
}

resource "random_string" "storage_suffix" {
  length  = 5
  upper   = false
  special = false
}

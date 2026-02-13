/*
===============================================================================
Secure Azure Foundation – Hardened Storage Configuration
-------------------------------------------------------------------------------
This storage account is restricted to private network access only.

Security Controls Implemented:
- TLS 1.2 enforced
- HTTPS-only traffic
- Public blob access disabled
- Public network access disabled
- Access restricted to private subnet
- System-assigned managed identity enabled

This configuration mitigates:
- Public data exposure
- Accidental anonymous access
- Credential interception via insecure transport
===============================================================================
*/

resource "azurerm_storage_account" "secure" {
  name                     = "stsecurefoundation${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version               = "TLS1_2"
  allow_blob_public_access      = false
  public_network_access_enabled = false
  enable_https_traffic_only     = true

  identity {
    type = "SystemAssigned"
  }

  network_rules {
    default_action = "Deny"

    virtual_network_subnet_ids = [
      azurerm_subnet.private.id
    ]

    bypass = ["AzureServices"]
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

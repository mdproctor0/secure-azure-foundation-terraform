/*
===============================================================================
Secure Azure Foundation – Provider Configuration
-------------------------------------------------------------------------------
This file configures the AzureRM provider used by Terraform to manage Azure
resources for this project.

Authentication Model:
- Development: Azure CLI authentication (recommended for local development)
    az login
- Production: Non-interactive authentication (service principal or managed
  identity) should be used to support automation and least privilege.
===============================================================================
*/

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

/*
===============================================================================
Secure Azure Foundation – Provider Configuration
-------------------------------------------------------------------------------
This file configures the AzureRM provider used by Terraform.

Design Rationale:
- Explicit provider declaration improves clarity
- Version pinning prevents unexpected breaking changes
- Authentication is handled via Azure CLI (az login)
===============================================================================
*/

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}

  # Authentication is expected via:
  #   az login
  #
  # For production environments, a service principal or managed identity
  # should be used instead of interactive login.
}

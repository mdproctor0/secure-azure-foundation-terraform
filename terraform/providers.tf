/*
===============================================================================
Secure Azure Foundation – Provider Configuration
-------------------------------------------------------------------------------
This file configures the AzureRM provider.

Authentication:
- This project assumes Azure CLI authentication for development:
    az login
- Production patterns (service principals / managed identity) are documented
  in the README and can be implemented later.
===============================================================================
*/

provider "azurerm" {
  features {}
}

/*
===============================================================================
Secure Azure Foundation – Core Infrastructure
-------------------------------------------------------------------------------
Defines the primary lifecycle boundary for this environment.

Scope:
- Resource Group (deployment, management, and cost boundary)

Design Notes:
- All resources in this baseline are deployed into this Resource Group
- Enables clean environment isolation and simplified teardown
===============================================================================
*/

###############################################################################
# Resource Group
###############################################################################

resource "azurerm_resource_group" "rg" {
  name     = "rg-secure-foundation"
  location = var.location

  tags = {
    environment = "secure-foundation"
    managed_by  = "terraform"
  }
}

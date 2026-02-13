/*
===============================================================================
Secure Azure Foundation – Core Infrastructure
-------------------------------------------------------------------------------
This file defines foundational infrastructure resources that serve as the
lifecycle boundary for the secure environment.

Scope:
- Resource Group (primary deployment boundary)

Design Rationale:
- The Resource Group acts as the management and cost boundary
- All resources are deployed within this group
- Enables simplified teardown and environment isolation
===============================================================================
*/

###############################################################################
# Resource Group (Lifecycle Boundary)
###############################################################################

resource "azurerm_resource_group" "rg" {
  name     = "rg-secure-foundation"
  location = var.location

  tags = {
    environment = "secure-foundation"
    managed_by  = "terraform"
  }
}

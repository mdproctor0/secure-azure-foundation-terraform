/*
===============================================================================
Secure Azure Foundation – Terraform & Provider Version Constraints
-------------------------------------------------------------------------------
This file pins Terraform and provider versions to ensure consistent behavior
across machines and over time.

Rationale:
- Prevents unexpected breaking changes from provider upgrades
- Ensures predictable initialization and deployments
===============================================================================
*/

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

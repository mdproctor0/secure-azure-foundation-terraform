/*
===============================================================================
Secure Azure Foundation – Terraform & Provider Version Constraints
-------------------------------------------------------------------------------
Defines required Terraform and provider versions to ensure deterministic
behavior across environments.

Purpose:
- Prevent unexpected breaking changes
- Maintain consistent deployments across machines
- Enforce controlled provider upgrades
===============================================================================
*/

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

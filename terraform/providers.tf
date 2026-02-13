/*
===============================================================================
Secure Azure Foundation – Provider Configuration
-------------------------------------------------------------------------------
Configures the AzureRM provider used by Terraform to provision and manage
Azure resources for this secure baseline.

Authentication Strategy:
- Development:
    Uses Azure CLI authentication.
    Run: az login

- Production:
    Use a Service Principal or Managed Identity to support:
    - Non-interactive deployments
    - CI/CD automation
    - Least-privilege access control

Security Note:
Provider-level settings can enforce safeguards. This configuration allows
controlled deletion during lab development. In production environments,
additional protections may be enforced.
===============================================================================
*/

provider "azurerm" {
  features {
    resource_group {
      # Set to true in production to prevent accidental RG deletion
      prevent_deletion_if_contains_resources = false
    }
  }
}

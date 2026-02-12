resource "azurerm_resource_group" "rg" {
  name     = "rg-secure-foundation"
  location = var.location
}

/*
resource → Terraform will manage this
"azurerm_resource_group" → Azure resource type
"rg" → internal Terraform name (local reference)
name → Azure-visible name
location → using variable (professional practice)
*/
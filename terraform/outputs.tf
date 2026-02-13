/*
===============================================================================
Secure Azure Foundation – Output Values
-------------------------------------------------------------------------------
This file defines values exported after Terraform apply.

Purpose:
- Expose important infrastructure attributes
- Enable downstream integrations (modules, monitoring, automation)
- Provide visibility into deployed resources without manual portal lookup

Outputs are especially important in:
- Modular architectures
- CI/CD pipelines
- Cross-environment promotion workflows
===============================================================================
*/

###############################################################################
# Virtual Machine Outputs
###############################################################################

output "vm_private_ip" {
  description = <<DESCRIPTION
Private IP address assigned to the Linux virtual machine.

Security Context:
- Confirms VM is deployed inside the private subnet
- Validates no public IP exposure
- Useful for Bastion connectivity verification

Used for:
- Network validation
- Log correlation
- Future automation scripts
DESCRIPTION

  value = azurerm_network_interface.vm_nic.private_ip_address
}

output "vm_id" {
  description = <<DESCRIPTION
Azure Resource ID of the Linux virtual machine.

Purpose:
- Required for monitoring integrations
- Used in extensions and diagnostics configuration
- Helpful for RBAC assignments and security tooling
DESCRIPTION

  value = azurerm_linux_virtual_machine.vm.id
}

###############################################################################
# Observability Outputs
###############################################################################

output "log_analytics_workspace_id" {
  description = <<DESCRIPTION
Resource ID of the Log Analytics Workspace.

Purpose:
- Confirms centralized logging deployment
- Enables future diagnostic settings integrations
- Supports security monitoring expansion
DESCRIPTION

  value = azurerm_log_analytics_workspace.law.id
}

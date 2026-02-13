/*
===============================================================================
Secure Azure Foundation – Output Values
-------------------------------------------------------------------------------
Defines values exported after Terraform apply.

Purpose:
- Expose important infrastructure attributes
- Enable downstream integrations (modules, monitoring, automation)
- Provide visibility without manual portal inspection

Outputs are critical for:
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
- Confirms VM resides in private subnet
- Validates absence of public IP
- Used for Bastion connectivity verification
DESCRIPTION

  value = azurerm_network_interface.vm_nic.private_ip_address
}

output "vm_id" {
  description = <<DESCRIPTION
Azure Resource ID of the Linux virtual machine.

Used for:
- Extensions and monitoring
- RBAC assignments
- Automation workflows
DESCRIPTION

  value = azurerm_linux_virtual_machine.vm.id
}

###############################################################################
# Networking Outputs
###############################################################################

output "vnet_id" {
  description = "Resource ID of the Virtual Network."
  value       = azurerm_virtual_network.vnet.id
}

output "bastion_host_id" {
  description = "Resource ID of the Azure Bastion host."
  value       = azurerm_bastion_host.bastion.id
}

###############################################################################
# Observability Outputs
###############################################################################

output "log_analytics_workspace_id" {
  description = <<DESCRIPTION
Resource ID of the Log Analytics Workspace.

Purpose:
- Confirms centralized logging deployment
- Enables future diagnostic integrations
- Supports security monitoring expansion
DESCRIPTION

  value = azurerm_log_analytics_workspace.law.id
}

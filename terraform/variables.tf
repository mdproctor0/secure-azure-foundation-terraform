/*
===============================================================================
Secure Azure Foundation – Variable Definitions
-------------------------------------------------------------------------------
This file defines configurable inputs for the Terraform deployment.

Design Goals:
- Avoid hardcoding values
- Improve portability across environments
- Enable safe customization without modifying core infrastructure code
- Support future expansion (multi-region, scaling, modularization)
===============================================================================
*/

###############################################################################
# Global / Environment Configuration
###############################################################################

variable "location" {
  description = <<DESCRIPTION
Azure region where all resources will be deployed.

Purpose:
- Keeps infrastructure region-agnostic
- Enables future multi-region deployments
- Prevents hardcoding region values in resource blocks

Default: centralus
DESCRIPTION

  type    = string
  default = "centralus"
}

###############################################################################
# Networking Configuration
###############################################################################

variable "vnet_cidr" {
  description = <<DESCRIPTION
CIDR block for the Virtual Network (VNet).

Purpose:
- Defines the private address space for the secure environment
- Serves as the network boundary for all deployed resources
- Must not overlap with existing networks (VPN, on-prem, etc.)

Default: 10.10.0.0/16
DESCRIPTION

  type    = string
  default = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
  description = <<DESCRIPTION
CIDR block for the public subnet.

Purpose:
- Segment reserved for controlled ingress resources
- Designed to remain restricted via NSGs
- Included for architectural completeness and future expansion

Default: 10.10.1.0/24
DESCRIPTION

  type    = string
  default = "10.10.1.0/24"
}

variable "private_subnet_cidr" {
  description = <<DESCRIPTION
CIDR block for the private subnet.

Purpose:
- Hosts sensitive resources (e.g., VM without public IP)
- Not directly accessible from the internet
- Supports secure-by-default architecture

Default: 10.10.2.0/24
DESCRIPTION

  type    = string
  default = "10.10.2.0/24"
}

###############################################################################
# Compute Configuration
###############################################################################

variable "vm_name" {
  description = <<DESCRIPTION
Name of the Linux virtual machine.

Purpose:
- Identifies the baseline secure compute instance
- Used for monitoring, alerting, and logging context
- Should follow naming standards in enterprise environments

Default: vm-secure-foundation-01
DESCRIPTION

  type    = string
  default = "vm-secure-foundation-01"
}

variable "admin_username" {
  description = <<DESCRIPTION
Administrator username for the Linux VM.

Security Note:
- Should not be 'root'
- Access should occur via SSH key authentication only
- Used for initial provisioning and management

Default: azureuser
DESCRIPTION

  type    = string
  default = "azureuser"
}

variable "ssh_public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key used for VM authentication.

Security Purpose:
- Enforces passwordless authentication
- Prevents brute-force password attacks
- Aligns with cloud security best practices

This should point to a local .pub key file.
DESCRIPTION

  type    = string
  default = "~/.ssh/tf_azure_baseline_rsa.pub"
}

variable "vm_size" {
  description = <<DESCRIPTION
Azure VM size for the Linux instance.

Purpose:
- Controls CPU, memory, and cost
- Can be adjusted depending on workload requirements
- Default chosen for balanced performance and lab environments

Example: Standard_D2s_v4
DESCRIPTION

  type    = string
  default = "Standard_D2s_v4"
}

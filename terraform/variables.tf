/*
===============================================================================
Secure Azure Foundation – Variable Definitions
-------------------------------------------------------------------------------
This file defines all configurable inputs for the Terraform deployment.

Design Principles:
- No hardcoded environment-specific values
- Portability across regions and subscriptions
- Secure-by-default configuration
- Clear documentation for maintainability
- Production-ready structure
===============================================================================
*/

###############################################################################
# Global Configuration
###############################################################################

variable "location" {
  description = <<EOT
Azure region where all resources will be deployed.

This variable ensures the infrastructure is region-agnostic and
prevents hardcoding location values directly in resource blocks.

Example: centralus
EOT

  type    = string
  default = "centralus"
}

###############################################################################
# Networking Configuration
###############################################################################

variable "vnet_cidr" {
  description = <<EOT
CIDR block for the Virtual Network (VNet).

Defines the private address space boundary for the environment.
Must not overlap with existing networks (VPN, ExpressRoute, or on-prem).

Example: 10.10.0.0/16
EOT

  type    = string
  default = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
  description = <<EOT
CIDR block for the public subnet.

Reserved for controlled ingress resources. Even though labeled "public",
all exposure is governed by Network Security Groups.

Example: 10.10.1.0/24
EOT

  type    = string
  default = "10.10.1.0/24"
}

variable "private_subnet_cidr" {
  description = <<EOT
CIDR block for the private subnet.

Intended for sensitive workloads that must not have direct internet
exposure (e.g., virtual machines without public IPs).

Example: 10.10.2.0/24
EOT

  type    = string
  default = "10.10.2.0/24"
}

variable "bastion_subnet_cidr" {
  description = <<EOT
CIDR block for the Azure Bastion subnet.

Azure Bastion requires a dedicated subnet named 'AzureBastionSubnet'.
A /26 or larger is commonly used.

Example: 10.10.3.0/26
EOT

  type    = string
  default = "10.10.3.0/26"
}

###############################################################################
# Compute Configuration
###############################################################################

variable "vm_name" {
  description = <<EOT
Name assigned to the Linux virtual machine.

Used for identification, logging context, and monitoring alignment.
Should follow consistent enterprise naming standards.

Example: vm-secure-foundation-01
EOT

  type    = string
  default = "vm-secure-foundation-01"
}

variable "admin_username" {
  description = <<EOT
Administrator username for the Linux VM.

Security Requirements:
- Must not be 'root'
- SSH key authentication is enforced
- Password-based login should remain disabled

Example: azureuser
EOT

  type    = string
  default = "azureuser"

  validation {
    condition     = var.admin_username != "root"
    error_message = "The administrator username cannot be 'root'."
  }
}

variable "ssh_public_key_path" {
  description = <<EOT
Path to the SSH public key used for VM authentication.

This variable intentionally has no default value to:
- Avoid committing machine-specific file paths
- Enforce explicit configuration
- Support portability across environments

Example:
  ~/.ssh/id_rsa.pub
EOT

  type = string
}

variable "vm_size" {
  description = <<EOT
Azure VM size for the Linux instance.

Determines compute resources and cost profile.
Can be adjusted based on workload requirements.

Example: Standard_D2s_v4
EOT

  type    = string
  default = "Standard_D2s_v4"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "centralus"
}

/*
Makes environment portable
Prevents hardcoding
Allows future multi-region expansion
*/


variable "vnet_cidr" {
  description = "CIDR block for the virtual network"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.10.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.10.2.0/24"
}


variable "vm_name" {
  description = "Name of the Linux VM"
  type        = string
  default     = "vm-secure-foundation-01"
}

variable "admin_username" {
  description = "Admin username for the Linux VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "/Users/marquellproctor/.ssh/tf_azure_baseline_rsa.pub"

}

variable "vm_size" {
  type    = string
  default = "Standard_D2s_v4"
}

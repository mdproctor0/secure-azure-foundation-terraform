output "vm_private_ip" {
  value       = azurerm_network_interface.vm_nic.private_ip_address
  description = "Private IP address of the VM"
}

output "vm_id" {
  value       = azurerm_linux_virtual_machine.vm.id
  description = "Resource ID of the VM"
}

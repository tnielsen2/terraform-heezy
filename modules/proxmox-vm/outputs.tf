output "vm_id" {
  description = "ID of the created VM"
  value       = proxmox_virtual_environment_vm.vm.id
}

output "vm_name" {
  description = "Name of the created VM"
  value       = proxmox_virtual_environment_vm.vm.name
}

output "vm_ip" {
  description = "IP address of the VM"
  value       = proxmox_virtual_environment_vm.vm.ipv4_addresses[1][0]
}
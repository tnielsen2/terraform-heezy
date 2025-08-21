output "vm_id" {
  description = "ID of the created VM"
  value       = proxmox_virtual_environment_vm.vm.vm_id
}

output "vm_name" {
  description = "Name of the created VM"
  value       = proxmox_virtual_environment_vm.vm.name
}

output "vm_ip" {
  description = "IP address of the VM (requires guest agent)"
  value       = length(proxmox_virtual_environment_vm.vm.ipv4_addresses) > 1 && length(proxmox_virtual_environment_vm.vm.ipv4_addresses[1]) > 0 ? proxmox_virtual_environment_vm.vm.ipv4_addresses[1][0] : null
}

output "vm_mac" {
  description = "MAC address of the VM"
  value       = proxmox_virtual_environment_vm.vm.mac_addresses[0]
}

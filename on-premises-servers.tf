# On-premises infrastructure - Proxmox VMs
# module "windows_vm1" {
#   source = "./modules/proxmox-vm"
#
#   vm_name       = "windows-vm-01"
#   target_node   = "proxmox"
#   template_name = "100" # server-2019-vm-template
#   vm_disk_size  = 100
#   os_type       = "windows"
# }

module "testvm1" {
  source = "./modules/proxmox-vm"

  vm_name       = "testvm1"
  target_node   = "proxmox"
  proxmox_vm_id = 105 # ubuntu-2024-vm-template-8-2025
  vm_disk_size  = 150
  os_type       = "linux"
}

module "testvm2" {
  source = "./modules/proxmox-vm"

  vm_name       = "testvm2"
  target_node   = "proxmox"
  proxmox_vm_id = 105 # ubuntu-2024-vm-template-8-2025
  vm_disk_size  = 150
  os_type       = "linux"
}

module "testvm3" {
  source = "./modules/proxmox-vm"

  vm_name       = "testvm3"
  target_node   = "proxmox"
  proxmox_vm_id = 105 # ubuntu-2024-vm-template-8-2025
  vm_disk_size  = 150
  os_type       = "linux"
}

module "testvm4" {
  source = "./modules/proxmox-vm"

  vm_name       = "testvm4"
  target_node   = "proxmox"
  proxmox_vm_id = 105 # ubuntu-2024-vm-template-8-2025
  vm_disk_size  = 150
  os_type       = "linux"
}


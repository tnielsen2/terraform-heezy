# On-premises infrastructure - Proxmox VMs
# module "windows_vm1" {
#   source = "./modules/proxmox-vm"
#
#   vm_name       = "windows-vm-01"
#   target_node   = "proxmox"
#   proxmox_vm_id = "100" # server-2019-vm-template
#   vm_disk_size  = 100
#   os_type       = "windows"
# }

module "linux_vm1" {
  source = "./modules/proxmox-vm"

  vm_name       = "ubuntu-vm-01"
  target_node   = "proxmox"
  proxmox_vm_id = 108 # ubuntu-2404-vm-template
  vm_disk_size  = 100
  os_type       = "linux"
}

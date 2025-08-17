# On-premises infrastructure - Proxmox VMs
# module "windows_vm1" {
#   source = "./modules/proxmox-vm"
#
#   vm_name       = "windows-vm-01"
#   target_node   = "proxmox"
#   template_name = "server-2019-vm-template"
#   vm_disk_size  = "100G"
#   os_type       = "windows"
# }

module "linux_vm1" {
  source = "./modules/proxmox-vm"

  vm_name       = "ubuntu-vm-01"
  target_node   = "proxmox"
  template_name = "ubuntu-2404-vm-template"
  vm_disk_size  = "100G"
  os_type       = "linux"
}
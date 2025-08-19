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

module "github_runner" {
  source = "./modules/proxmox-vm"

  vm_name             = "github-runner"
  target_node         = "proxmox"
  proxmox_vm_id       = 105 # ubuntu-2024-vm-template-8-2025
  vm_disk_size        = 150
  os_type             = "linux"
  ansible_custom_role = "github-runner"
}

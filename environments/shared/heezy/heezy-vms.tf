# Heezy VMs - Proxmox Infrastructure
# module "windows_vm1" {
#   source = "../../../shared/modules/proxmox-vm"
#
#   vm_name       = "windows-vm-01"
#   target_node   = "proxmox"
#   template_name = "100" # server-2019-vm-template
#   vm_disk_size  = 100
#   os_type       = "windows"
# }
#
module "shared_pxe" {
  source = "../../../shared/modules/proxmox-vm"

  providers = {
    proxmox = proxmox.proxmox
  }

  vm_name           = "shared-pxe"
  target_node       = "proxmox"
  proxmox_vm_id     = 105 # ubuntu-2024-vm-template-8-2025
  vm_disk_size      = 150
  os_type           = "linux"
  ansible_playbooks = "baseline"
  vm_vlan_id        = 1
}

module "shared_dnsmasq" {
  source = "../../../shared/modules/proxmox-vm"

  providers = {
    proxmox = proxmox.proxmox
  }

  vm_name           = "shared-dnsmasq"
  target_node       = "proxmox"
  proxmox_vm_id     = 105 # ubuntu-2024-vm-template-8-2025
  vm_disk_size      = 150
  os_type           = "linux"
  ansible_playbooks = "baseline"
  vm_vlan_id        = 1
}

module "shared_lgtm" {
  source = "../../../shared/modules/proxmox-vm"

  providers = {
    proxmox = proxmox.proxmox
  }

  vm_name           = "shared-lgtm"
  target_node       = "proxmox"
  proxmox_vm_id     = 105 # ubuntu-2024-vm-template-8-2025
  vm_disk_size      = 150
  os_type           = "linux"
  ansible_playbooks = "prometheus"
  vm_vlan_id        = 1
}


module "shared_github_runner" {
  source = "../../../shared/modules/proxmox-vm"

  providers = {
    proxmox = proxmox.proxmox
  }

  vm_name           = "shared-github-runner"
  target_node       = "proxmox"
  proxmox_vm_id     = 105 # ubuntu-2024-vm-template-8-2025
  vm_disk_size      = 150
  vm_cores          = 4
  vm_sockets        = 2
  vm_memory         = 8192
  os_type           = "linux"
  ansible_playbooks = "baseline,github-runner"
  vm_vlan_id        = 1
}

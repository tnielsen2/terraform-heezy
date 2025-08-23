# DMZ VMs - Proxmox Infrastructure

module "dmz_minecraft" {
  source = "../../../shared/modules/proxmox-vm"

  providers = {
    proxmox = proxmox.proxmox
  }

  vm_name           = "dmz-minecraft"
  target_node       = "proxmox"
  proxmox_vm_id     = 105 # ubuntu-2024-vm-template-8-2025
  vm_disk_size      = 150
  os_type           = "linux"
  ansible_playbooks = "baseline"
  vm_vlan_id        = 3
}
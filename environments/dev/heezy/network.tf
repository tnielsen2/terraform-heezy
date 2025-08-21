# Proxmox Network Configuration - Dev VLAN

resource "proxmox_virtual_environment_network_linux_vlan" "vlan1000" {
  node_name = "proxmox"
  name      = "vlan1000"
  interface = "vmbr0"
  vlan      = 1000
  comment   = "Dev VLAN 1000"
}
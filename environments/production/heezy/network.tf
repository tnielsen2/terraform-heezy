# Proxmox Network Configuration - Production VLAN

resource "proxmox_virtual_environment_network_linux_vlan" "vlan2000" {
  node_name = "proxmox"
  name      = "vlan2000"
  interface = "vmbr0"
  vlan      = 2000
  comment   = "Production VLAN 2000"
}
# Example of creating a VM template from ISO (commented out by default)
# Uncomment and modify as needed

/*
resource "proxmox_vm_qemu" "windows_template" {
  name        = "server-2019-template"
  target_node = "proxmox-01"
  
  # ISO configuration
  iso         = "local:iso/windows-server-2019.iso"
  
  cores   = 2
  sockets = 1
  memory  = 4096
  
  disk {
    slot    = 0
    size    = "50G"
    type    = "scsi"
    storage = "local-lvm"
  }
  
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  
  os_type = "win10"
  
  # Template configuration
  template = true
  
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}
*/
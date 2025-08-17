resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.vm_name
  node_name = var.target_node

  clone {
    vm_id = var.proxmox_vm_id
  }

  agent {
    enabled = true
  }

  stop_on_destroy = false

  cpu {
    cores   = var.vm_cores
    sockets = 1
  }

  memory {
    dedicated = var.vm_memory
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = var.vm_disk_size
  }

  network_device {
    bridge = "vmbr0"
  }
}

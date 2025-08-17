resource "proxmox_vm_qemu" "vm" {
  name        = var.vm_name
  target_node = var.target_node
  clone       = var.template_name

  cores   = var.vm_cores
  sockets = 1
  memory  = var.vm_memory
  scsihw  = var.scsihw

  clone_wait = 3600 # 1 hour timeout for clone operations

  disk {
    slot    = 0
    size    = var.vm_disk_size
    type    = "scsi"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  os_type = var.os_type == "windows" ? "win10" : "l26"

  lifecycle {
    ignore_changes = [network]
  }

  timeouts {
    create = "60m"
    update = "60m"
    delete = "10m"
  }
}
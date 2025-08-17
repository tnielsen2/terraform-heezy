resource "proxmox_vm_qemu" "vm" {
  name        = var.vm_name
  target_node = var.target_node
  clone       = var.template_name

  cores   = var.vm_cores
  sockets = 1
  memory  = var.vm_memory
  scsihw  = var.scsihw

  clone_wait = 7200 # 2 hour timeout for clone operations
  agent      = 1    # Enable QEMU guest agent for better monitoring

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
    create = "120m" # Increased to 2 hours
    update = "120m"
    delete = "10m"
  }

  provisioner "local-exec" {
    command     = "ansible-playbook -i '${self.default_ipv4_address},' playbook.yml"
    working_dir = "../../ansible-runner-bootstrap"
  }
}
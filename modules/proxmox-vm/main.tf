resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.vm_name
  node_name = var.target_node

  clone {
    vm_id = var.proxmox_vm_id
  }

  agent {
    enabled = true
  }

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

  provisioner "local-exec" {
    command     = "ansible-playbook -i '${self.ipv4_addresses[1][0]},' playbook.yml"
    working_dir = "../../ansible-runner-bootstrap"
  }
}

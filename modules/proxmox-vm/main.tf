resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.vm_name
  node_name = var.target_node

  clone {
    vm_id = var.proxmox_vm_id
  }

  agent {
    enabled = true
  }

  stop_on_destroy = true
  protection      = false # Prevent accidental deletion

  timeout_clone       = 7200 # 2 hours
  timeout_create      = 7200 # 2 hours
  timeout_migrate     = 3600 # 1 hour
  timeout_reboot      = 3600 # 1 hour
  timeout_shutdown_vm = 3600 # 1 hour
  timeout_start_vm    = 3600 # 1 hour
  timeout_stop_vm     = 600  # 10 minutes

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

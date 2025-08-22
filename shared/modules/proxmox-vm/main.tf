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

  timeout_clone       = 7200
  timeout_create      = 7200
  timeout_migrate     = 3600
  timeout_reboot      = 3600
  timeout_shutdown_vm = 3600
  timeout_start_vm    = 3600
  timeout_stop_vm     = 600

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
    bridge  = var.vm_bridge
    vlan_id = var.vm_vlan_id
  }

  provisioner "local-exec" {
    command = <<-EOT
      # Get GitHub token from AWS Secrets Manager and parse JSON
      GH_TOKEN=$(aws secretsmanager get-secret-value \
        --region us-east-2 \
        --secret-id "all/heezy/github/runner/personal-access-token" \
        --query SecretString --output text | jq -r '.token')
      
      # Trigger GitHub workflow
      curl -X POST \
        -H "Authorization: Bearer $GH_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        https://api.github.com/repos/${var.ansible_repo}/actions/workflows/terraform-triggered.yml/dispatches \
        -d '{
          "ref": "main",
          "inputs": {
            "target_hosts": "${self.ipv4_addresses[1][0]}",
            "playbooks": "${var.ansible_playbooks}"
          }
        }'
    EOT
  }
}

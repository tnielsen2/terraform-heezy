# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Heezy Environment Outputs - Proxmox VMs

output "linux_vms" {
  description = "Linux VM information"
  value = {
    vm1 = {
      id   = module.github_runner.vm_id
      name = module.github_runner.vm_name
      ip   = module.github_runner.vm_ip
      mac  = module.github_runner.vm_mac
    }
  }
}
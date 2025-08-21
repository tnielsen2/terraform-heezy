# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Heezy Environment Outputs - Proxmox VMs

output "linux_vms" {
  description = "Shared Linux VMs"
  value = {
    vm1 = {
      id   = module.shared_pxe.vm_id
      name = module.shared_pxe.vm_name
      ip   = module.shared_pxe.vm_ip
      mac  = module.shared_pxe.vm_mac
    }
    vm2 = {
      id   = module.shared_dnsmasq.vm_id
      name = module.shared_dnsmasq.vm_name
      ip   = module.shared_dnsmasq.vm_ip
      mac  = module.shared_dnsmasq.vm_mac
    }
  }
}

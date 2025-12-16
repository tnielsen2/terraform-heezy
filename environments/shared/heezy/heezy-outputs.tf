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
    vm3 = {
      id   = module.shared_lgtm.vm_id
      name = module.shared_lgtm.vm_name
      ip   = module.shared_lgtm.vm_ip
      mac  = module.shared_lgtm.vm_mac
    }
    vm4 = {
      id   = module.shared_github_runner.vm_id
      name = module.shared_github_runner.vm_name
      ip   = module.shared_github_runner.vm_ip
      mac  = module.shared_github_runner.vm_mac
    }
    vm5 = {
      id   = module.shared_omni.vm_id
      name = module.shared_omni.vm_name
      ip   = module.shared_omni.vm_ip
      mac  = module.shared_omni.vm_mac
    }
    vm6 = {
      id   = module.tailscale_exit_node.vm_id
      name = module.tailscale_exit_node.vm_name
      ip   = module.tailscale_exit_node.vm_ip
      mac  = module.tailscale_exit_node.vm_mac
    }
  }
}

# Ansible Integration - Trigger containerized Ansible automation after VM provisioning

# Trigger Ansible automation via GitHub workflow dispatch with custom role support
resource "null_resource" "ansible_provisioning" {
  depends_on = [
    module.linux_vm1,
    # module.windows_vm1
  ]

  provisioner "local-exec" {
    command = <<-EOT
      gh workflow run ansible-provision.yml \
        --repo ${var.ansible_repo} \
        -f target_hosts="${module.linux_vm1.vm_ip}" \
        -f linux_host="${module.linux_vm1.vm_ip}" \
        -f playbook="${var.ansible_playbook}" \
        -f custom_role="${var.ansible_custom_role}" \
        -f environment="production"
    EOT
  }

  triggers = {
    linux_vm_ip = module.linux_vm1.vm_ip
    # windows_vm_ip = module.windows_vm1.vm_ip
    playbook    = var.ansible_playbook
    custom_role = var.ansible_custom_role
  }
}

# Optional: Trigger specific role for individual VMs
resource "null_resource" "linux_custom_role" {
  count = var.ansible_linux_role != "" ? 1 : 0

  depends_on = [module.linux_vm1]

  provisioner "local-exec" {
    command = <<-EOT
      gh workflow run ansible-provision.yml \
        --repo ${var.ansible_repo} \
        -f target_hosts="${module.linux_vm1.vm_ip}" \
        -f playbook="custom-role" \
        -f custom_role="${var.ansible_linux_role}" \
        -f environment="production"
    EOT
  }

  triggers = {
    vm_ip = module.linux_vm1.vm_ip
    role  = var.ansible_linux_role
  }
}

# resource "null_resource" "windows_custom_role" {
#   count = var.ansible_windows_role != "" ? 1 : 0
#   
#   depends_on = [module.windows_vm1]
#
#   provisioner "local-exec" {
#     command = <<-EOT
#       gh workflow run ansible-provision.yml \
#         --repo ${var.ansible_repo} \
#         -f target_hosts="${module.windows_vm1.vm_ip}" \
#         -f playbook="custom-role" \
#         -f custom_role="${var.ansible_windows_role}" \
#         -f environment="production"
#     EOT
#   }
#
#   triggers = {
#     vm_ip = module.windows_vm1.vm_ip
#     role = var.ansible_windows_role
#   }
# }
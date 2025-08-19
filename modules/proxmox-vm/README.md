# proxmox-vm

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | ~> 0.66 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 0.81.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_virtual_environment_vm.vm](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ansible_custom_role"></a> [ansible\_custom\_role](#input\_ansible\_custom\_role) | Custom Ansible role | `string` | `""` | no |
| <a name="input_ansible_playbook"></a> [ansible\_playbook](#input\_ansible\_playbook) | Ansible playbook to run | `string` | `"baseline"` | no |
| <a name="input_ansible_repo"></a> [ansible\_repo](#input\_ansible\_repo) | GitHub repository for Ansible automation | `string` | `"tnielsen2/ansible-heezy"` | no |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | OS type: windows or linux | `string` | n/a | yes |
| <a name="input_proxmox_vm_id"></a> [proxmox\_vm\_id](#input\_proxmox\_vm\_id) | Template VM ID to clone from | `string` | n/a | yes |
| <a name="input_target_node"></a> [target\_node](#input\_target\_node) | Proxmox node to deploy VM on | `string` | n/a | yes |
| <a name="input_vm_cores"></a> [vm\_cores](#input\_vm\_cores) | Number of CPU cores | `number` | `2` | no |
| <a name="input_vm_disk_size"></a> [vm\_disk\_size](#input\_vm\_disk\_size) | Disk size in GB | `number` | `100` | no |
| <a name="input_vm_memory"></a> [vm\_memory](#input\_vm\_memory) | Memory in MB | `number` | `4096` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | Name of the VM | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vm_id"></a> [vm\_id](#output\_vm\_id) | ID of the created VM |
| <a name="output_vm_ip"></a> [vm\_ip](#output\_vm\_ip) | IP address of the VM (requires guest agent) |
| <a name="output_vm_name"></a> [vm\_name](#output\_vm\_name) | Name of the created VM |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

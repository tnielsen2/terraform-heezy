# proxmox-vm

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 2.9.14 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_vm_qemu.vm](https://registry.terraform.io/providers/telmate/proxmox/latest/docs/resources/vm_qemu) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | OS type: windows or linux | `string` | n/a | yes |
| <a name="input_scsihw"></a> [scsihw](#input\_scsihw) | SCSI controller type | `string` | `"virtio-scsi-pci"` | no |
| <a name="input_target_node"></a> [target\_node](#input\_target\_node) | Proxmox node to deploy VM on | `string` | n/a | yes |
| <a name="input_template_name"></a> [template\_name](#input\_template\_name) | Template to clone from | `string` | n/a | yes |
| <a name="input_vm_cores"></a> [vm\_cores](#input\_vm\_cores) | Number of CPU cores | `number` | `2` | no |
| <a name="input_vm_disk_size"></a> [vm\_disk\_size](#input\_vm\_disk\_size) | Disk size | `string` | `"100G"` | no |
| <a name="input_vm_memory"></a> [vm\_memory](#input\_vm\_memory) | Memory in MB | `number` | `4096` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | Name of the VM | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vm_id"></a> [vm\_id](#output\_vm\_id) | ID of the created VM |
| <a name="output_vm_ip"></a> [vm\_ip](#output\_vm\_ip) | IP address of the VM |
| <a name="output_vm_name"></a> [vm\_name](#output\_vm\_name) | Name of the created VM |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

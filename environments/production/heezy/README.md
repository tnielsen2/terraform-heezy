# Production Heezy Environment

Production Proxmox VMs and FortiGate interface configuration.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_fortios"></a> [fortios](#requirement\_fortios) | ~> 1.20 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 0.81.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |
| <a name="provider_fortios"></a> [fortios](#provider\_fortios) | 1.22.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_github_runner"></a> [github\_runner](#module\_github\_runner) | ../../../shared/modules/proxmox-vm | n/a |

## Resources

| Name | Type |
|------|------|
| [fortios_system_interface.prod_vlan_2000](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/system_interface) | resource |
| [aws_secretsmanager_secret_version.fortigate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_version.proxmox](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS Region for secrets access | `string` | `"us-east-2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_linux_vms"></a> [linux\_vms](#output\_linux\_vms) | Linux VM information |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

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
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 0.81.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [fortios_firewall_address.prod_github_runner](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_address) | resource |
| [fortios_firewall_address.talos_five](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_address) | resource |
| [fortios_firewall_address.talos_four](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_address) | resource |
| [fortios_firewall_address.talos_one](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_address) | resource |
| [fortios_firewall_address.talos_three](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_address) | resource |
| [fortios_firewall_address.talos_two](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_address) | resource |
| [fortios_firewall_addrgrp.talos_nodes](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_addrgrp) | resource |
| [fortios_firewall_policy.allow_github_runner](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_policy) | resource |
| [fortios_firewall_policy.allow_github_runner_fw_mgmt](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_policy) | resource |
| [fortios_firewall_policy.prod_to_wan](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_policy) | resource |
| [fortios_system_interface.prod_vlan_2000](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/system_interface) | resource |
| [fortios_system_zone.prod](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/system_zone) | resource |
| [fortios_systemdhcp_server.prod_vlan_2000](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/systemdhcp_server) | resource |
| [proxmox_virtual_environment_network_linux_vlan.vlan2000](https://registry.terraform.io/providers/bpg/proxmox/0.81.0/docs/resources/virtual_environment_network_linux_vlan) | resource |
| [aws_secretsmanager_secret_version.fortigate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_version.proxmox](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS Region for secrets access | `string` | `"us-east-2"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

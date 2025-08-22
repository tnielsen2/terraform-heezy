# heezy

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
| <a name="module_shared_dnsmasq"></a> [shared\_dnsmasq](#module\_shared\_dnsmasq) | ../../../shared/modules/proxmox-vm | n/a |
| <a name="module_shared_lgtm"></a> [shared\_lgtm](#module\_shared\_lgtm) | ../../../shared/modules/proxmox-vm | n/a |
| <a name="module_shared_pxe"></a> [shared\_pxe](#module\_shared\_pxe) | ../../../shared/modules/proxmox-vm | n/a |

## Resources

| Name | Type |
|------|------|
| [fortios_firewall_address.fortigate_shared_mgmt](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_address) | resource |
| [fortios_firewall_address.heezy_users](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_address) | resource |
| [fortios_firewall_address.shared_github_runner](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_address) | resource |
| [fortios_firewall_policy.allow_github_runner_shared_fw_mgmt3](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_policy) | resource |
| [fortios_firewall_policy.allow_heezy_users_fw_mgmt](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_policy) | resource |
| [fortios_firewall_policy.shared_to_wan](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_policy) | resource |
| [fortios_firewallservice_custom.tcp_22](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewallservice_custom) | resource |
| [fortios_firewallservice_custom.tcp_8006](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewallservice_custom) | resource |
| [fortios_firewallservice_custom.tcp_8443](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewallservice_custom) | resource |
| [fortios_system_interface.dmz](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/system_interface) | resource |
| [fortios_system_interface.internal7](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/system_interface) | resource |
| [fortios_system_interface.users_vlan_200](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/system_interface) | resource |
| [fortios_system_zone.shared](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/system_zone) | resource |
| [fortios_system_zone.users](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/system_zone) | resource |
| [fortios_systemdhcp_server.shared_internal7_dhcp](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/systemdhcp_server) | resource |
| [fortios_systemdhcp_server.shared_users_vlan_200_dhcp](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/systemdhcp_server) | resource |
| [aws_secretsmanager_secret_version.fortigate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_version.proxmox](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS Region for secrets access | `string` | `"us-east-2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_linux_vms"></a> [linux\_vms](#output\_linux\_vms) | Shared Linux VMs |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

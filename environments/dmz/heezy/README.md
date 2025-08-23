# DMZ Environment

DMZ infrastructure configuration for isolated services.

## Resources

- **DMZ Zone**: Isolated zone with no interfaces initially
- **DMZ Minecraft VM**: Ubuntu VM on VLAN 3 for minecraft services
- **Firewall Policies**: 
  - DMZ outbound access (NAT enabled)
  - Minecraft remote access (port 19132 UDP)
  - Minecraft survival remote access

## Usage

```bash
cd environments/dmz/heezy
terraform init
terraform apply
```

## Dependencies

- Shared minecraft service objects (managed in shared/heezy)
- DMZ zone and firewall policies (managed here)<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
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
| <a name="module_dmz_minecraft"></a> [dmz\_minecraft](#module\_dmz\_minecraft) | ../../../shared/modules/proxmox-vm | n/a |

## Resources

| Name | Type |
|------|------|
| [fortios_firewall_address.minecraft_server](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_address) | resource |
| [fortios_firewall_address.minecraft_survival_server](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_address) | resource |
| [fortios_firewall_policy.dmz_outbound](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_policy) | resource |
| [fortios_firewall_policy.minecraft_remote_access](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_policy) | resource |
| [fortios_firewall_policy.minecraft_survival_remote_access](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_policy) | resource |
| [fortios_system_zone.dmz](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/system_zone) | resource |
| [aws_secretsmanager_secret_version.fortigate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_version.proxmox](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS Region for secrets access | `string` | `"us-east-2"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

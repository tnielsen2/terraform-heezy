# terraform-heezy

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
| <a name="module_testvm1"></a> [testvm1](#module\_testvm1) | ./modules/proxmox-vm | n/a |
| <a name="module_testvm2"></a> [testvm2](#module\_testvm2) | ./modules/proxmox-vm | n/a |
| <a name="module_testvm3"></a> [testvm3](#module\_testvm3) | ./modules/proxmox-vm | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_customer_gateway.fortigate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customer_gateway) | resource |
| [aws_db_instance.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_instance.postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_ecr_lifecycle_policy.ansible_automation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_lifecycle_policy.github_runner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.ansible_automation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.github_runner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_instance.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_key_pair.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_networkmanager_core_network.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_core_network) | resource |
| [aws_networkmanager_global_network.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_global_network) | resource |
| [aws_networkmanager_vpc_attachment.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_vpc_attachment) | resource |
| [aws_security_group.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpn_connection.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection) | resource |
| [aws_vpn_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway) | resource |
| [fortios_firewall_address.aws_vpc](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_address) | resource |
| [fortios_firewall_address.k8s](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_address) | resource |
| [fortios_firewall_address.onprem_summary](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_address) | resource |
| [fortios_firewall_address.servers](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_address) | resource |
| [fortios_firewall_address.users](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/firewall_address) | resource |
| [fortios_router_bgp.main](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/router_bgp) | resource |
| [fortios_routerbgp_neighbor.aws](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/routerbgp_neighbor) | resource |
| [fortios_routerbgp_network.onprem](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/routerbgp_network) | resource |
| [fortios_system_zone.aws](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/system_zone) | resource |
| [fortios_vpnipsec_phase1interface.aws_tunnel](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/vpnipsec_phase1interface) | resource |
| [fortios_vpnipsec_phase2interface.aws_tunnel](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/vpnipsec_phase2interface) | resource |
| [aws_secretsmanager_secret_version.fortigate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_version.proxmox](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ansible_custom_role"></a> [ansible\_custom\_role](#input\_ansible\_custom\_role) | Custom Ansible role to apply (overrides default) | `string` | `""` | no |
| <a name="input_ansible_linux_role"></a> [ansible\_linux\_role](#input\_ansible\_linux\_role) | Specific role for Linux VM (e.g., minecraft-server) | `string` | `""` | no |
| <a name="input_ansible_playbook"></a> [ansible\_playbook](#input\_ansible\_playbook) | Default Ansible playbook to run | `string` | `"vm-bootstrap"` | no |
| <a name="input_ansible_repo"></a> [ansible\_repo](#input\_ansible\_repo) | GitHub repository for Ansible automation | `string` | `"your-org/ansible-automation"` | no |
| <a name="input_ansible_windows_role"></a> [ansible\_windows\_role](#input\_ansible\_windows\_role) | Specific role for Windows VM (e.g., game-server) | `string` | `""` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Heezy Proxmox VM Provisioning | `string` | `"terraform-proxmox"` | no |
| <a name="input_region"></a> [region](#input\_region) | Default AWS Region | `string` | `"us-east-2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_instances"></a> [ec2\_instances](#output\_ec2\_instances) | EC2 instance information |
| <a name="output_linux_vms"></a> [linux\_vms](#output\_linux\_vms) | Linux VM information |
| <a name="output_rds_endpoints"></a> [rds\_endpoints](#output\_rds\_endpoints) | RDS database endpoints |
| <a name="output_vpc_info"></a> [vpc\_info](#output\_vpc\_info) | VPC information |
| <a name="output_vpn_connection"></a> [vpn\_connection](#output\_vpn\_connection) | VPN connection details |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

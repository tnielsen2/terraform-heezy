# terraform-heezy

Heezy Infrastructure as Code - Multi-environment Terraform configuration

## Structure

```
terraform-heezy/
├── environments/
│   ├── production/
│   │   ├── heezy/          # On-prem prod resources
│   │   └── aws/            # AWS
│   └── dev/
│       ├── heezy/          # On-prem dev resources
│       └── aws/            # AWS
├── shared/
│   └── modules/
│       └── proxmox-vm/     # Shared VM module
└── docs/
```

## Usage

### Production Environment
```bash
# Heezy infrastructure
cd environments/production/heezy
terraform init
terraform apply

# AWS infrastructure
cd environments/production/aws
terraform init
terraform apply
```

### Dev Environment
```bash
# Heezy infrastructure
cd environments/dev/heezy
terraform init
terraform apply

# AWS infrastructure
cd environments/dev/aws
terraform init
terraform apply
```

## Requirements

- AWS CLI configured
- Terraform >= 1.0
- Access to Proxmox host (192.168.1.144)
- FortiGate firewall (192.168.1.1)

See `docs/HEEZY_SETUP.md` for detailed setup instructions.

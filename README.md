# terraform-heezy

Heezy Infrastructure as Code - Multi-environment Terraform configuration

## Structure

```
terraform-heezy/
├── environments/
│   ├── production/
│   │   ├── heezy/          # Production Proxmox VMs
│   │   └── aws/            # Production AWS + FortiGate
│   ├── dev/
│   │   ├── heezy/          # Dev Proxmox VMs
│   │   └── aws/            # Dev AWS + FortiGate
│   └── shared/
│       ├── heezy/          # Shared FortiGate interfaces
│       └── aws/            # Shared AWS resources
├── shared/
│   └── modules/
│       └── proxmox-vm/     # Shared VM module
└── docs/
    ├── ANSIBLE_INTEGRATION.md
    ├── FORTIGATE_IMPORT.md
    └── HEEZY_SETUP.md
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

### Shared Infrastructure
```bash
# Shared FortiGate interfaces
cd environments/shared/heezy
terraform init
terraform apply

# Shared AWS resources (if any)
cd environments/shared/aws
terraform init
terraform apply
```

## Requirements

- AWS CLI configured
- Terraform >= 1.0
- Access to Proxmox host (192.168.1.144)
- FortiGate firewall (192.168.1.1)

See documentation in `docs/` for detailed instructions:
- `HEEZY_SETUP.md` - Initial setup and configuration
- `ANSIBLE_INTEGRATION.md` - VM configuration management
- `FORTIGATE_IMPORT.md` - Importing existing FortiGate interfaces

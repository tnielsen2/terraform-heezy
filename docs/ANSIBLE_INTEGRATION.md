# Ansible Integration with Terraform

## Architecture Overview

This setup uses **GitHub Actions workflow dispatch** to trigger Ansible configuration management after VM provisioning, providing automated post-deployment configuration.

## Repository Structure

```
terraform-heezy/           # Infrastructure as Code
├── environments/
│   ├── production/
│   │   ├── heezy/         # Production Proxmox VMs
│   │   └── aws/           # Production AWS + FortiGate
│   ├── dev/
│   │   ├── heezy/         # Dev Proxmox VMs
│   │   └── aws/           # Dev AWS + FortiGate
│   └── shared/
│       ├── heezy/         # Shared FortiGate interfaces
│       └── aws/           # Shared AWS resources
├── shared/
│   └── modules/
│       └── proxmox-vm/    # Shared VM module
└── docs/

ansible-heezy/             # Separate Ansible repository
├── .github/workflows/
│   └── terraform-triggered.yml
├── playbooks/
│   ├── baseline.yml
│   └── github-runner.yml
└── roles/
    ├── baseline/
    └── github-runner/
```

## Implementation

### 1. VM Provisioning Flow

1. **Terraform Apply**: Creates VM via Proxmox provider
2. **VM Boot**: VM starts and gets IP address via DHCP
3. **Provisioner Execution**: `local-exec` provisioner triggers after VM is ready
4. **GitHub Workflow Dispatch**: Calls Ansible repository workflow
5. **Ansible Configuration**: Runs specified playbooks on the new VM

### 2. Proxmox VM Module Integration

The `shared/modules/proxmox-vm` module includes a `local-exec` provisioner:

```hcl
provisioner "local-exec" {
  command = <<-EOT
    # Get GitHub token from AWS Secrets Manager
    GH_TOKEN=$(aws secretsmanager get-secret-value \
      --region us-east-2 \
      --secret-id "all/heezy/github/runner/personal-access-token" \
      --query SecretString --output text | jq -r '.token')
    
    # Trigger GitHub workflow
    curl -X POST \
      -H "Authorization: Bearer $GH_TOKEN" \
      -H "Accept: application/vnd.github.v3+json" \
      https://api.github.com/repos/tnielsen2/${var.ansible_repo}/actions/workflows/terraform-triggered.yml/dispatches \
      -d '{
        "ref": "main",
        "inputs": {
          "target_hosts": "${self.ipv4_addresses[1][0]}",
          "playbooks": "${var.ansible_playbooks}"
        }
      }'
  EOT
}
```

### 3. Module Variables

```hcl
variable "ansible_repo" {
  type        = string
  description = "GitHub repository for Ansible automation"
  default     = "tnielsen2/ansible-heezy"
}

variable "ansible_playbooks" {
  type        = string
  description = "Comma-separated list of playbooks to run"
  default     = "baseline"
}
```

## Usage Examples

### Production GitHub Runner

```hcl
# environments/production/heezy/heezy-vms.tf
module "github_runner" {
  source = "../../../shared/modules/proxmox-vm"
  
  providers = {
    proxmox = proxmox.proxmox_610
  }

  vm_name           = "github-runner"
  target_node       = "proxmox"
  proxmox_vm_id     = 105
  vm_disk_size      = 150
  os_type           = "linux"
  ansible_playbooks = "baseline,github-runner"
}
```

### Dev Environment VM

```hcl
# environments/dev/heezy/heezy-vms.tf
module "dev_runner" {
  source = "../../../shared/modules/proxmox-vm"
  
  providers = {
    proxmox = proxmox.proxmox_610
  }

  vm_name           = "dev-runner"
  target_node       = "proxmox"
  proxmox_vm_id     = 105
  vm_disk_size      = 100
  os_type           = "linux"
  ansible_playbooks = "baseline"
}
```

## Prerequisites

### 1. GitHub Personal Access Token

Store in AWS Secrets Manager:
- **Secret Name**: `all/heezy/github/runner/personal-access-token`
- **Format**: `{"token": "ghp_xxxxxxxxxxxx"}`

### 2. Ansible Repository Setup

The `ansible-heezy` repository should contain:
- **Workflow**: `.github/workflows/terraform-triggered.yml`
- **Playbooks**: Individual playbook files
- **Roles**: Ansible roles for configuration

### 3. Self-Hosted Runner Requirements

- Network access to Proxmox VMs
- AWS CLI configured for secrets access
- Docker installed (if using containerized Ansible)

## Workflow Dispatch

### Automatic Trigger

When `terraform apply` creates a VM, the provisioner automatically:
1. Fetches GitHub token from AWS Secrets Manager
2. Calls the `terraform-triggered.yml` workflow
3. Passes VM IP and playbook list as inputs

### Manual Trigger

You can also trigger Ansible manually:

```bash
gh workflow run terraform-triggered.yml \
  -f target_hosts="192.168.1.100" \
  -f playbooks="baseline,github-runner"
```

## Playbook Configuration

### Single Playbook
```hcl
ansible_playbooks = "baseline"
```

### Multiple Playbooks
```hcl
ansible_playbooks = "baseline,github-runner"
```

### Custom Playbooks
```hcl
ansible_playbooks = "baseline,custom-app,monitoring"
```

## Benefits

- **Automated Configuration**: VMs are automatically configured after provisioning
- **Separation of Concerns**: Infrastructure and configuration management are separate
- **Flexibility**: Easy to add new playbooks and roles
- **Consistency**: Same configuration process across all environments
- **Auditability**: All configuration changes tracked in Git
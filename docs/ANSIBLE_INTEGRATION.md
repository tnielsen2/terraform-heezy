# Ansible Integration with Terraform - Containerized Approach

## Architecture Overview

This setup uses **containerized Ansible** triggered via GitHub workflow dispatch, providing clean separation and consistent execution environments.

## Repository Structure

```
terraform-heezy/           # Infrastructure as Code
├── environments/
│   ├── production/
│   │   ├── heezy/         # Proxmox VMs
│   │   └── aws/           # AWS + FortiGate
│   └── dev/
│       ├── heezy/         # Dev Proxmox VMs
│       └── aws/           # Dev AWS + FortiGate
├── shared/
│   └── modules/
│       └── proxmox-vm/    # Shared VM module
└── docs/

ansible-automation/        # Separate Ansible repository
├── .github/workflows/
│   └── terraform-triggered.yml
├── Dockerfile            # Ansible container
├── playbooks/
│   ├── baseline.yml
│   ├── github-runner.yml
│   └── custom-roles.yml
├── roles/
│   ├── minecraft-server/
│   ├── web-server/
│   └── game-server/
└── inventory/
```

## Implementation Approach

### 1. VM Bootstrapping Process

**Terraform → Proxmox → Ansible Pipeline:**
1. **VM Creation**: Terraform creates VM from template via Proxmox API
2. **IP Assignment**: VM boots and gets IP via DHCP/cloud-init
3. **Provisioner Trigger**: Terraform `local-exec` provisioner automatically triggers Ansible
4. **Configuration Management**: Ansible configures VM based on specified playbooks

### 2. Provisioner Integration

The `proxmox-vm` module includes a `local-exec` provisioner that:
- **Waits for VM**: VM must be running and have IP address
- **Fetches GitHub Token**: From AWS Secrets Manager
- **Triggers Workflow**: Dispatches GitHub Actions workflow with VM details
- **Passes Variables**: VM IP and playbook list to Ansible

```hcl
provisioner "local-exec" {
  command = <<-EOT
    # Get GitHub token from AWS Secrets Manager
    GH_TOKEN=$(aws secretsmanager get-secret-value \
      --region us-east-2 \
      --secret-id "all/heezy/github/runner/personal-access-token" \
      --query SecretString --output text | jq -r '.token')
    
    # Trigger GitHub workflow with VM details
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

### 3. Containerized Ansible Execution
- **Why**: Consistent environment, dependency isolation, version control
- **Benefits**: Reproducible builds, easy updates, no host pollution
- **Execution**: Docker container built and run on self-hosted runner

### 4. Custom Role Support
- **Default roles**: `baseline` for basic VM configuration
- **Custom roles**: Add specific roles like `github-runner`, `minecraft-server`
- **Flexible**: Can target individual VMs or groups

### 5. Self-Hosted Runner with Docker Buildx
- **Network access**: Reaches both on-prem and AWS resources
- **Docker capabilities**: Builds and runs Ansible containers
- **Tools**: GitHub CLI, Docker Buildx, Terraform

## Setup Instructions

### Step 1: Updated Runner Bootstrap

The runner now includes:
- **Docker CE with Buildx plugin**
- **GitHub CLI for workflow dispatch**
- **Enhanced security packages**
- **No Ansible installation** (containerized instead)

### Step 2: Create Ansible Repository

Create `ansible-automation` repository with containerized setup:

```dockerfile
# Dockerfile
FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    openssh-client \
    sshpass \
    && rm -rf /var/lib/apt/lists/*

RUN pip install ansible ansible-core

WORKDIR /ansible
COPY . .

ENTRYPOINT ["ansible-playbook"]
```

```yaml
# .github/workflows/ansible-provision.yml
name: Ansible Provisioning

on:
  workflow_dispatch:
    inputs:
      target_hosts:
        description: 'Comma-separated list of target hosts'
        required: true
      linux_host:
        description: 'Linux host IP'
        required: false
      windows_host:
        description: 'Windows host IP'
        required: false
      playbook:
        description: 'Playbook to run'
        required: true
        default: 'vm-bootstrap'
      custom_role:
        description: 'Custom role to apply (overrides default)'
        required: false
        default: ''
      environment:
        description: 'Environment'
        required: true
        default: 'production'

jobs:
  ansible:
    runs-on: self-hosted
    steps:
      - uses: actions/checkout@v4
      
      - name: Build Ansible Container
        run: |
          docker build -t ansible-runner:latest .
      
      - name: Run Ansible Playbook
        run: |
          case "${{ inputs.playbook }}" in
            "vm-bootstrap")
              if [[ -n "${{ inputs.linux_host }}" ]]; then
                docker run --rm --network host \
                  -v $(pwd):/ansible \
                  ansible-runner:latest \
                  -i "${{ inputs.linux_host }}," \
                  playbooks/linux-setup.yml
              fi
              if [[ -n "${{ inputs.windows_host }}" ]]; then
                docker run --rm --network host \
                  -v $(pwd):/ansible \
                  ansible-runner:latest \
                  -i "${{ inputs.windows_host }}," \
                  playbooks/windows-setup.yml
              fi
              ;;
            "custom-role")
              if [[ -n "${{ inputs.custom_role }}" ]]; then
                docker run --rm --network host \
                  -v $(pwd):/ansible \
                  ansible-runner:latest \
                  -i "${{ inputs.target_hosts }}" \
                  playbooks/custom-role.yml \
                  --extra-vars "target_role=${{ inputs.custom_role }}"
              fi
              ;;
            *)
              docker run --rm --network host \
                -v $(pwd):/ansible \
                ansible-runner:latest \
                -i "${{ inputs.target_hosts }}" \
                playbooks/${{ inputs.playbook }}.yml
              ;;
          esac
```

### Step 3: Create Ansible Playbooks

```yaml
# playbooks/custom-role.yml
---
- hosts: all
  become: yes
  tasks:
    - name: Apply custom role
      include_role:
        name: "{{ target_role }}"
      when: target_role is defined
```

```yaml
# roles/minecraft-server/tasks/main.yml
---
- name: Install Java
  apt:
    name: openjdk-17-jre-headless
    state: present

- name: Create minecraft user
  user:
    name: minecraft
    system: yes
    shell: /bin/bash
    home: /opt/minecraft

- name: Download Minecraft server
  get_url:
    url: "https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar"
    dest: /opt/minecraft/server.jar
    owner: minecraft
    group: minecraft

- name: Create server.properties
  template:
    src: server.properties.j2
    dest: /opt/minecraft/server.properties
    owner: minecraft
    group: minecraft

- name: Accept EULA
  copy:
    content: "eula=true"
    dest: /opt/minecraft/eula.txt
    owner: minecraft
    group: minecraft

- name: Create systemd service
  template:
    src: minecraft.service.j2
    dest: /etc/systemd/system/minecraft.service
  notify: restart minecraft

- name: Start and enable minecraft service
  systemd:
    name: minecraft
    state: started
    enabled: yes
    daemon_reload: yes
```

### Step 4: Configure Terraform Integration

#### Module Variables for Role Provisioning

The `proxmox-vm` module accepts these key variables:

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

#### VM Configuration Examples

```hcl
# Production GitHub Runner
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
  
  # Ansible configuration
  ansible_repo      = "tnielsen2/ansible-heezy"
  ansible_playbooks = "baseline,github-runner"
}

# Dev Environment VM
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
  
  # Minimal Ansible configuration for dev
  ansible_playbooks = "baseline"
}

# Custom Application Server
module "minecraft_server" {
  source = "../../../shared/modules/proxmox-vm"
  
  providers = {
    proxmox = proxmox.proxmox_610
  }

  vm_name           = "minecraft-01"
  target_node       = "proxmox"
  proxmox_vm_id     = 105
  vm_disk_size      = 200
  vm_memory         = 8192
  vm_cores          = 4
  os_type           = "linux"
  
  # Custom role provisioning
  ansible_playbooks = "baseline,minecraft-server"
}
```

#### Playbook Execution Flow

1. **VM Creation**: Terraform creates VM and waits for IP
2. **Provisioner Execution**: `local-exec` runs after VM is ready
3. **Workflow Dispatch**: GitHub Actions workflow triggered with:
   - `target_hosts`: VM IP address
   - `playbooks`: Comma-separated list (e.g., "baseline,github-runner")
4. **Ansible Execution**: Workflow runs specified playbooks in order

### Step 5: Usage Examples

**Default VM Bootstrap:**
```bash
terraform apply
# Triggers default linux-setup and windows-setup roles
```

**Custom Playbooks:**
```bash
# Multiple playbooks (current approach)
ansible_playbooks = "baseline,minecraft-server"

# Single playbook
ansible_playbooks = "github-runner"
```

## Benefits of Containerized Approach

### ✅ Pros
- **Consistent environment**: Same Ansible version everywhere
- **Dependency isolation**: No conflicts with host system
- **Version control**: Container images are versioned
- **Security**: Isolated execution environment
- **Portability**: Runs anywhere Docker is available
- **Custom roles**: Easy to add specialized configurations

### ⚠️ Considerations
- **Network**: Container needs `--network host` for VM access
- **Build time**: Container build adds execution time
- **Storage**: Docker images consume disk space

## Custom Role Development

### Adding New Roles

1. **Create role structure**:
   ```
   roles/minecraft-server/
   ├── tasks/main.yml
   ├── templates/
   ├── vars/main.yml
   └── handlers/main.yml
   ```

2. **Use in Terraform**:
   ```hcl
   module "game_server" {
     source = "../../../shared/modules/proxmox-vm"
     
     vm_name           = "minecraft-01"
     target_node       = "proxmox"
     proxmox_vm_id     = 105
     vm_disk_size      = 200
     os_type           = "linux"
     ansible_playbooks = "baseline,minecraft-server"
   }
   ```

3. **Test role**:
   ```bash
   # Automatic via Terraform
   terraform apply
   
   # Manual trigger
   gh workflow run terraform-triggered.yml \
     -f target_hosts="192.168.1.100" \
     -f playbooks="minecraft-server"
   ```

## Available Variables

### Proxmox VM Module Variables

| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `vm_name` | VM name | - | `github-runner` |
| `target_node` | Proxmox node | - | `proxmox` |
| `proxmox_vm_id` | Template VM ID | - | `105` |
| `os_type` | OS type | - | `linux` or `windows` |
| `vm_cores` | CPU cores | `2` | `4` |
| `vm_memory` | Memory in MB | `4096` | `8192` |
| `vm_disk_size` | Disk size in GB | `100` | `200` |
| `ansible_repo` | Ansible repository | `tnielsen2/ansible-heezy` | `myorg/ansible-automation` |
| `ansible_playbooks` | Comma-separated playbooks | `baseline` | `baseline,github-runner,minecraft-server` |

### Role Provisioning Examples

```hcl
# Basic VM with minimal configuration
ansible_playbooks = "baseline"

# GitHub Actions runner
ansible_playbooks = "baseline,github-runner"

# Game server with custom configuration
ansible_playbooks = "baseline,minecraft-server,firewall-config"

# Web server with SSL and monitoring
ansible_playbooks = "baseline,nginx,ssl-certs,monitoring"
```

## Workflow Integration

### Automatic Provisioning Flow

1. **VM Deployment**: `terraform apply` creates VM
2. **IP Detection**: Terraform waits for VM to get IP address
3. **Automatic Trigger**: Provisioner dispatches GitHub workflow
4. **Ansible Execution**: Workflow runs specified playbooks
5. **Configuration Complete**: VM is fully configured and ready

### Manual Triggers

You can also trigger Ansible independently:

```bash
# Trigger specific playbook on existing VM
gh workflow run terraform-triggered.yml \
  -f target_hosts="192.168.1.100" \
  -f playbooks="minecraft-server"

# Re-run configuration on multiple VMs
gh workflow run terraform-triggered.yml \
  -f target_hosts="192.168.1.100,192.168.1.101" \
  -f playbooks="baseline,monitoring"
```

### Prerequisites for Bootstrapping

1. **GitHub Personal Access Token**: Stored in AWS Secrets Manager
   - Secret: `all/heezy/github/runner/personal-access-token`
   - Format: `{"token": "ghp_xxxxxxxxxxxx"}`

2. **Self-Hosted Runner**: Must have network access to VMs
   - Docker installed for containerized Ansible
   - AWS CLI configured for secrets access
   - GitHub CLI for workflow dispatch

3. **VM Template Requirements**:
   - Cloud-init enabled
   - SSH key authentication configured
   - Python installed for Ansible

This approach provides maximum flexibility while maintaining clean separation between infrastructure provisioning and configuration management.
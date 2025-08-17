# Ansible Integration with Terraform - Containerized Approach

## Architecture Overview

This setup uses **containerized Ansible** triggered via GitHub workflow dispatch, providing clean separation and consistent execution environments.

## Repository Structure

```
terraform-heezy/           # Infrastructure as Code
├── ansible-integration.tf # Ansible trigger configuration
├── modules/proxmox-vm/   # VM provisioning
└── ...

ansible-automation/        # Separate Ansible repository
├── .github/workflows/
│   └── ansible-provision.yml
├── Dockerfile            # Ansible container
├── playbooks/
│   ├── vm-bootstrap.yml
│   ├── linux-setup.yml
│   ├── windows-setup.yml
│   └── custom-role.yml
├── roles/
│   ├── minecraft-server/
│   ├── web-server/
│   └── game-server/
└── inventory/
```

## Implementation Approach

### 1. Containerized Ansible Execution
- **Why**: Consistent environment, dependency isolation, version control
- **Benefits**: Reproducible builds, easy updates, no host pollution
- **Execution**: Docker container built and run on self-hosted runner

### 2. Custom Role Support
- **Default roles**: `linux-setup`, `windows-setup` for basic VM configuration
- **Custom roles**: Override with specific roles like `minecraft-server`
- **Flexible**: Can target individual VMs or groups

### 3. Self-Hosted Runner with Docker Buildx
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

```hcl
# terraform.tfvars
ansible_repo = "your-org/ansible-automation"

# For custom roles
ansible_linux_role = "minecraft-server"
# ansible_windows_role = "game-server"
```

### Step 5: Usage Examples

**Default VM Bootstrap:**
```bash
terraform apply
# Triggers default linux-setup and windows-setup roles
```

**Custom Role for Minecraft Server:**
```bash
terraform apply -var="ansible_linux_role=minecraft-server"
# Applies minecraft-server role to Linux VM
```

**Custom Playbook:**
```bash
terraform apply -var="ansible_playbook=web-server"
# Runs web-server.yml playbook
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
   ansible_linux_role = "minecraft-server"
   ```

3. **Test role**:
   ```bash
   gh workflow run ansible-provision.yml \
     -f target_hosts="192.168.1.100" \
     -f playbook="custom-role" \
     -f custom_role="minecraft-server"
   ```

## Available Variables

| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `ansible_repo` | Ansible repository | `your-org/ansible-automation` | `myorg/ansible` |
| `ansible_playbook` | Default playbook | `vm-bootstrap` | `web-server` |
| `ansible_custom_role` | Global custom role | `""` | `minecraft-server` |
| `ansible_linux_role` | Linux-specific role | `""` | `minecraft-server` |
| `ansible_windows_role` | Windows-specific role | `""` | `game-server` |

## Workflow Integration

The integration supports multiple execution patterns:

1. **Default bootstrap**: Applies basic configuration to all VMs
2. **Custom role override**: Applies specific role instead of default
3. **Individual VM roles**: Different roles for Linux vs Windows VMs
4. **Manual triggers**: Can be triggered independently via GitHub Actions

This approach provides maximum flexibility while maintaining clean separation between infrastructure provisioning and configuration management.
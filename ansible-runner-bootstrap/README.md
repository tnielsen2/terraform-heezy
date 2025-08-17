# GitHub Actions Runner Bootstrap

This directory contains Ansible automation to bootstrap a fresh GitHub Actions self-hosted runner.

## Prerequisites

1. **Fresh Ubuntu/Debian server** with SSH access
2. **GitHub Personal Access Token** with `repo` and `admin:repo_hook` permissions
3. **SSH key access** to the target server
4. **Sudo access** on the target server

## Setup Instructions

### 1. Generate GitHub Token
Go to GitHub Settings > Developer settings > Personal access tokens
Create token with `repo` and `admin:repo_hook` permissions

### 2. Set up SSH Key Access
Copy your SSH public key to the runner server:

**Method 1: Using ssh-copy-id (easiest)**
```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub user@192.168.1.100
```

**Method 2: Manual copy**
```bash
cat ~/.ssh/id_rsa.pub | ssh user@192.168.1.100 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

**Method 3: If you have password access**
```bash
# Copy your public key
cat ~/.ssh/id_rsa.pub

# SSH to the runner server with password
ssh user@192.168.1.100

# On the runner server
mkdir -p ~/.ssh
echo "paste_your_public_key_here" >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

Test SSH access:
```bash
ssh -i ~/.ssh/id_rsa user@192.168.1.100
```

### 3. Configure Sudo Access

**Option A: Passwordless sudo (recommended)**
SSH to your runner and run:
```bash
sudo visudo
```
Add this line (replace `trent` with your username):
```
trent ALL=(ALL) NOPASSWD:ALL
```

**Option B: Use sudo password**
The script will prompt for your sudo password during execution.

### 4. Run Bootstrap
```bash
./run.sh <runner_ip> <ssh_user> <github_token> [ssh_key_path]
```

**Example:**
```bash
./run.sh 192.168.1.100 trent ghp_xxxxxxxxxxxx ~/.ssh/id_rsa
```

**Arguments:**
- `runner_ip`: IP address of your runner server
- `ssh_user`: SSH username for the server
- `github_token`: GitHub personal access token
- `ssh_key_path`: Path to SSH private key (optional, defaults to ~/.ssh/id_rsa)

The script will:
1. Install Ansible if not present
2. Create temporary inventory file
3. Prompt for sudo password (if passwordless sudo not configured)
4. Run the Ansible playbook
5. Clean up temporary files

## What Gets Installed

- **System packages**: curl, wget, unzip, jq, git, gpg
- **AWS CLI v2**: Latest version from official installer
- **Terraform**: Latest from HashiCorp repository
- **GitHub Actions Runner**: Latest release, configured as service
- **Runner user**: Dedicated user for running actions

## Manual Commands

If you prefer to run manually:

```bash
# Install Ansible (if needed)
brew install ansible  # macOS
# or
sudo apt-get install ansible  # Linux

# Update inventory.yml with your details, then:
GITHUB_TOKEN=your_token ansible-playbook -i inventory.yml playbook.yml --ask-become-pass
```

## Troubleshooting

**SSH Connection Issues:**
- Ensure SSH key is added to the server's authorized_keys
- Test SSH connection manually first
- Check firewall settings on the runner server

**Sudo Password Issues:**
- Set up passwordless sudo for easier automation
- Ensure the user is in the sudo group
- Use `--ask-become-pass` flag for manual runs

**GitHub Token Issues:**
- Ensure token has `repo` and `admin:repo_hook` permissions
- Check token hasn't expired
- Verify repository name is correct in playbook.yml

## Verification

After running, verify the runner appears in:
- GitHub Repository Settings > Actions > Runners

The runner will be named `heezy-runner` and have labels: `self-hosted`, `linux`, `x64`.

## Security Notes

- SSH keys are more secure than passwords
- Use passwordless sudo only on trusted systems
- GitHub tokens should be kept secure and rotated regularly
- The runner will have access to your repository secrets
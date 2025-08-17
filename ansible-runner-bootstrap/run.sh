#!/bin/bash

# GitHub Actions Runner Bootstrap Script
# Usage: ./run.sh <runner_ip> <ssh_user> <github_token> [ssh_key_path]

set -e

# Parse command line arguments
RUNNER_IP="$1"
SSH_USER="$2"
GITHUB_TOKEN="$3"
SSH_KEY="${4:-~/.ssh/id_rsa}"

# Check required arguments
if [ -z "$RUNNER_IP" ] || [ -z "$SSH_USER" ] || [ -z "$GITHUB_TOKEN" ]; then
    echo "Usage: $0 <runner_ip> <ssh_user> <github_token> [ssh_key_path]"
    echo "Example: $0 192.168.1.100 trent ghp_xxxxxxxxxxxx ~/.ssh/id_rsa"
    exit 1
fi

# Check if Ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    echo "Installing Ansible..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install ansible
    else
        sudo apt-get update && sudo apt-get install -y ansible
    fi
fi

# Create temporary inventory file
cat > /tmp/runner_inventory.yml << EOF
all:
  hosts:
    runner:
      ansible_host: $RUNNER_IP
      ansible_user: $SSH_USER
      ansible_ssh_private_key_file: $SSH_KEY
      ansible_become: yes
      ansible_become_method: sudo
EOF

echo "Connecting to runner at $RUNNER_IP as $SSH_USER..."
echo "Using SSH key: $SSH_KEY"

# Prompt for sudo password
echo "Enter sudo password for $SSH_USER on $RUNNER_IP:"
read -s SUDO_PASSWORD

# Run the playbook with credentials
echo "Running Ansible playbook to bootstrap runner..."
GITHUB_TOKEN="$GITHUB_TOKEN" ansible-playbook -i /tmp/runner_inventory.yml playbook.yml --extra-vars "ansible_become_password=$SUDO_PASSWORD"

# Clean up
rm -f /tmp/runner_inventory.yml

echo "Runner bootstrap complete!"
echo "The runner should now be available in your GitHub repository settings."
# FortiGate Credential Setup

## AWS Secrets Manager Configuration

Create the following secrets in AWS Secrets Manager:

### 1. Proxmox Credentials
**Secret Name:** `production/heezy/terraform/proxmox/secret`

**Secret Value (JSON):**
```json
{
  "username": "terraform@pve",
  "password": "your-proxmox-password"
}
```

### 2. FortiGate Credentials
**Secret Name:** `production/heezy/terraform/fortigate/secret`

**Secret Value (JSON):**
```json
{
  "username": "admin",
  "password": "your-fortigate-password"
}
```

## Creating Secrets via AWS CLI

```bash
# Create Proxmox secret
aws secretsmanager create-secret \
  --name "production/heezy/terraform/proxmox/secret" \
  --description "Proxmox credentials for Terraform" \
  --secret-string '{"username":"terraform@pve","password":"your-proxmox-password"}'

# Create FortiGate secret
aws secretsmanager create-secret \
  --name "production/heezy/terraform/fortigate/secret" \
  --description "FortiGate credentials for Terraform" \
  --secret-string '{"username":"admin","password":"your-fortigate-password"}'
```

## IAM Permissions Required

The Terraform execution role needs the following permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue"
      ],
      "Resource": [
        "arn:aws:secretsmanager:us-east-2:*:secret:production/heezy/terraform/proxmox/secret*",
        "arn:aws:secretsmanager:us-east-2:*:secret:production/heezy/terraform/fortigate/secret*"
      ]
    }
  ]
}
```

## FortiGate Configuration

Ensure your FortiGate has:
- Admin user with API access enabled
- Accessible from the Terraform execution environment
- Proper firewall rules for management access
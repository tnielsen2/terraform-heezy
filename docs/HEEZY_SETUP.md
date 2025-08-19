# Heezy Infrastructure Setup

## Architecture Overview
- **On-premises**: Proxmox VMs + FortiGate firewall
- **AWS**: VPCs, Cloud WAN, EC2, RDS
- **Connectivity**: IPSec VPN tunnels

## 1. Proxmox Host Setup (192.168.1.144)

### Create API User
```bash
# SSH into Proxmox host
pveum user add terraform@pve
pveum passwd terraform@pve
pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"
pveum aclmod / -user terraform@pve -role TerraformProv
```

### Verify Template Exists
```bash
# List available templates
qm list | grep template
```

## 2. AWS Secrets Manager Setup

Create secrets in AWS Secrets Manager for both environments:

### Production Proxmox Credentials
**Secret Name:** `production/heezy/terraform/proxmox/secret`
```json
{
  "username": "terraform@pve",
  "password": "your-proxmox-password"
}
```

### Production FortiGate Credentials
**Secret Name:** `production/heezy/terraform/fortigate/secret`
```json
{
  "username": "admin",
  "password": "your-fortigate-password"
}
```

### Dev Environment Secrets
**Secret Names:** 
- `dev/heezy/terraform/proxmox/secret`
- `dev/heezy/terraform/fortigate/secret`

(Same JSON structure as production)

### Create Secrets via AWS CLI
```bash
# Production secrets
aws secretsmanager create-secret \
  --name "production/heezy/terraform/proxmox/secret" \
  --description "Proxmox credentials for Terraform" \
  --secret-string '{"username":"terraform@pve","password":"your-proxmox-password"}'

aws secretsmanager create-secret \
  --name "production/heezy/terraform/fortigate/secret" \
  --description "FortiGate credentials for Terraform" \
  --secret-string '{"username":"admin","password":"your-fortigate-password"}'

# Dev secrets
aws secretsmanager create-secret \
  --name "dev/heezy/terraform/proxmox/secret" \
  --description "Dev Proxmox credentials for Terraform" \
  --secret-string '{"username":"terraform@pve","password":"your-proxmox-password"}'

aws secretsmanager create-secret \
  --name "dev/heezy/terraform/fortigate/secret" \
  --description "Dev FortiGate credentials for Terraform" \
  --secret-string '{"username":"admin","password":"your-fortigate-password"}'
```

## 3. IAM Permissions Required

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
        "arn:aws:secretsmanager:us-east-2:*:secret:production/heezy/terraform/fortigate/secret*",
        "arn:aws:secretsmanager:us-east-2:*:secret:dev/heezy/terraform/proxmox/secret*",
        "arn:aws:secretsmanager:us-east-2:*:secret:dev/heezy/terraform/fortigate/secret*"
      ]
    }
  ]
}
```

## 4. FortiGate Configuration

Ensure your FortiGate has:
- Admin user with API access enabled
- Accessible from the Terraform execution environment
- Proper firewall rules for management access

## 5. Network Configuration

Default configuration uses `vmbr0` bridge. Adjust in modules if your setup differs.

## 6. Storage Configuration

Default uses `local-lvm` storage. Verify this exists on your Proxmox host:
```bash
pvesm status
```

## 7. Workspace-Based Deployment

### Production Environment
```bash
# Heezy infrastructure (Proxmox VMs)
cd environments/production/heezy
terraform init
terraform plan
terraform apply

# AWS infrastructure (FortiGate + AWS resources)
cd environments/production/aws
terraform init
terraform plan
terraform apply
```

### Dev Environment
```bash
# Heezy infrastructure
cd environments/dev/heezy
terraform init
terraform plan
terraform apply

# AWS infrastructure
cd environments/dev/aws
terraform init
terraform plan
terraform apply
```

### State Files
Each workspace maintains separate state:
- `production/heezy/terraform.tfstate`
- `production/aws/terraform.tfstate`
- `dev/heezy/terraform.tfstate`
- `dev/aws/terraform.tfstate`
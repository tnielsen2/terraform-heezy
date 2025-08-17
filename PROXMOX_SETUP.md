# Hybrid Infrastructure Setup for Terraform

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
# Should show server-2019-vm-template
```

## 2. AWS Secrets Manager Setup

Create secrets in AWS Secrets Manager:

### Secret: `production/heezy/terraform/proxmox/secret`
```json
{
  "username": "terraform@pve",
  "password": "your_password_here"
}
```

## 3. Template Creation from ISO (Optional)

If you need to create the Windows Server 2019 template:

1. Upload ISO to Proxmox storage
2. Uncomment the template creation code in `template-creation.tf`
3. Run `terraform apply` to create the template
4. Convert VM to template manually in Proxmox UI or via CLI:
   ```bash
   qm template <vm_id>
   ```

## 4. Terraform Commands

```bash
# Initialize
terraform init

# Plan
terraform plan

# Apply
terraform apply

# Destroy
terraform destroy
```

## 5. Network Configuration

Default configuration uses `vmbr0` bridge. Adjust in `main.tf` if your setup differs.

## 6. Storage Configuration

Default uses `local-lvm` storage. Verify this exists on your Proxmox host:
```bash
pvesm status
```

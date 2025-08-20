# Terraform Import Commands

## FortiGate Zone Imports

Run these commands from `environments/shared/heezy/`:

```bash
# Import existing zones
terraform import fortios_system_zone.servers SERVERS
terraform import fortios_system_zone.users USERS

# Verify imports
terraform plan
```

## Interface Imports (if needed)

If you need to import existing interfaces:

```bash
# From environments/shared/heezy/
terraform import fortios_system_interface.internal7 internal7
terraform import fortios_system_interface.users_vlan_200 users-vlan-200

# From environments/production/heezy/
terraform import fortios_system_interface.prod_vlan_2000 prod-vlan-2000

# From environments/dev/heezy/
terraform import fortios_system_interface.dev_vlan_1000 dev-vlan-1000
```

## Deployment Order

1. **Configure Cisco Switch** (manual or Ansible)
2. **Configure Proxmox VLAN-aware bridge** (manual)
3. **Import existing FortiGate zones**:
   ```bash
   cd environments/shared/heezy
   terraform import fortios_system_zone.servers SERVERS
   terraform import fortios_system_zone.users USERS
   terraform apply
   ```
4. **Deploy environment-specific interfaces**:
   ```bash
   cd environments/production/heezy
   terraform apply
   
   cd environments/dev/heezy
   terraform apply
   ```
5. **Deploy VMs with VLAN assignments**
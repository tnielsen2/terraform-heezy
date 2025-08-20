# FortiGate Interface Import Guide

## Overview
This guide covers importing existing FortiGate interfaces into Terraform management.

## Prerequisites
- SSH access to FortiGate firewall
- Terraform configured with FortiOS provider
- AWS credentials for secrets access

## Import Process

### 1. Get Interface Configuration
SSH to FortiGate and retrieve the interface configuration:

```bash
# For physical interfaces
show system interface internal7

# For VLAN interfaces  
show system interface users-vlan-200
```

### 2. Create Terraform Resource
Based on the FortiGate output, create the corresponding Terraform resource in `environments/shared/heezy/interfaces.tf`:

**Physical Interface Example:**
```hcl
resource "fortios_system_interface" "internal7" {
  name              = "internal7"
  vdom              = "root"
  ip                = "192.168.1.1 255.255.255.0"
  allowaccess       = "ping https ssh http"
  type              = "physical"
  monitor_bandwidth = "enable"
  snmp_index        = 8

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}
```

**VLAN Interface Example:**
```hcl
resource "fortios_system_interface" "users_vlan_200" {
  name                     = "users-vlan-200"
  vdom                     = "root"
  ip                       = "192.168.2.1 255.255.255.0"
  allowaccess              = "ping https ssh http"
  device_identification   = "enable"
  role                     = "lan"
  snmp_index               = 9
  interface                = "internal7"
  vlanid                   = 200

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}
```

### 3. Import the Resource
```bash
cd environments/shared/heezy
terraform init
terraform import fortios_system_interface.internal7 internal7
terraform import fortios_system_interface.users_vlan_200 users-vlan-200
```

### 4. Verify Import
```bash
terraform plan
```

Should show "No changes" if configuration matches exactly.

## Configuration Mapping

| FortiGate Config | Terraform Attribute |
|------------------|-------------------|
| `set ip` | `ip` |
| `set allowaccess` | `allowaccess` |
| `set type physical` | `type` |
| `set monitor-bandwidth enable` | `monitor_bandwidth` |
| `set snmp-index` | `snmp_index` |
| `set device-identification enable` | `device_identification` |
| `set role lan` | `role` |
| `set interface "parent"` | `interface` |
| `set vlanid 200` | `vlanid` |

## Important Notes

1. **Lifecycle Block**: Always include the lifecycle block to ignore provider-specific parameters
2. **Import ID**: Use the exact interface name from FortiGate as the import ID
3. **Attribute Names**: Some FortiGate parameters use underscores in Terraform (e.g., `device-identification` → `device_identification`)
4. **No Apply Needed**: Import only brings resources into state - no changes are made to FortiGate

## Troubleshooting

- **"Resource does not exist"**: Ensure the Terraform resource is created before importing
- **Plan shows changes**: Add missing attributes or use lifecycle ignore_changes
- **Import fails**: Verify interface name and FortiGate connectivity
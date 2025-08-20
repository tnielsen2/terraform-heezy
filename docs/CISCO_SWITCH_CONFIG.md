# Cisco 3650 Switch Configuration for VLAN Trunking

## VLAN Configuration

```cisco
# Create VLANs
vlan 1000
 name DEV
vlan 2000
 name PROD

# Configure trunk port to Proxmox host (adjust interface as needed)
interface GigabitEthernet1/0/1
 description "Trunk to Proxmox Host"
 switchport mode trunk
 switchport trunk allowed vlan 1,200,1000,2000
 switchport trunk native vlan 1
 no shutdown

# Configure trunk port to FortiGate internal7 (adjust interface as needed)
interface GigabitEthernet1/0/2
 description "Trunk to FortiGate internal7"
 switchport mode trunk
 switchport trunk allowed vlan 1,200,1000,2000
 switchport trunk native vlan 1
 no shutdown
```

## Verification Commands

```cisco
# Verify VLAN configuration
show vlan brief

# Verify trunk configuration
show interfaces trunk

# Verify specific interface
show interface GigabitEthernet1/0/1 switchport
```

## Ansible Alternative

If you prefer Ansible for switch configuration, create this playbook:

```yaml
# playbooks/cisco-switch-vlans.yml
---
- name: Configure Cisco Switch VLANs
  hosts: cisco_switches
  gather_facts: no
  vars:
    ansible_network_os: ios
    ansible_connection: network_cli
  
  tasks:
    - name: Create VLANs
      cisco.ios.ios_vlans:
        config:
          - vlan_id: 1000
            name: DEV
          - vlan_id: 2000
            name: PROD
        state: merged
    
    - name: Configure trunk interfaces
      cisco.ios.ios_l2_interfaces:
        config:
          - name: "{{ item.interface }}"
            trunk:
              allowed_vlans: "1,200,1000,2000"
              native_vlan: 1
            mode: trunk
        state: merged
      loop:
        - { interface: "GigabitEthernet1/0/1" }  # Proxmox
        - { interface: "GigabitEthernet1/0/2" }  # FortiGate
```

## Proxmox Host Network Configuration

Configure Proxmox to handle VLAN trunking:

```bash
# /etc/network/interfaces on Proxmox host
auto vmbr0
iface vmbr0 inet static
    address 192.168.1.144/24
    gateway 192.168.1.1
    bridge-ports eno1
    bridge-stp off
    bridge-fd 0
    bridge-vlan-aware yes
    bridge-vids 2-4094

# VLAN interfaces for management
auto vmbr0.1000
iface vmbr0.1000 inet static
    address 192.168.100.144/24

auto vmbr0.2000
iface vmbr0.2000 inet static
    address 192.168.200.144/24
```
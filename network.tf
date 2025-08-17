# FortiGate and IPSec tunnel configuration

data "aws_secretsmanager_secret_version" "fortigate" {
  secret_id = "production/terraform-proxmox/heezy/fortigate/secret"
}

locals {
  fortigate_creds = jsondecode(data.aws_secretsmanager_secret_version.fortigate.secret_string)
}

provider "fortios" {
  hostname = "192.168.1.1"
  username = local.fortigate_creds.username
  password = local.fortigate_creds.password
  insecure = "true"
}

# IPSec Phase 1 Interface
resource "fortios_vpnipsec_phase1interface" "aws_tunnel" {
  name           = "aws-tunnel"
  interface      = "wan1"
  peertype       = "any"
  proposal       = "aes128-sha256 aes256-sha256"
  dhgrp          = "14 5"
  remote_gw      = aws_vpn_connection.main.tunnel1_address
  psksecret      = aws_vpn_connection.main.tunnel1_preshared_key
  dpd_retrycount = 3
  dpd_retryinterval = 60
}

# IPSec Phase 2 Interface
resource "fortios_vpnipsec_phase2interface" "aws_tunnel" {
  name      = "aws-tunnel"
  phase1name = fortios_vpnipsec_phase1interface.aws_tunnel.name
  proposal  = "aes128-sha1 aes256-sha1"
  dhgrp     = "5 14"
  src_subnet = "192.168.1.0/24"
  dst_subnet = "10.0.0.0/16"
}

# Static route for AWS traffic
resource "fortios_router_static" "aws_route" {
  seq_num  = 1
  dst      = "10.0.0.0/16"
  device   = fortios_vpnipsec_phase1interface.aws_tunnel.name
  priority = 10
}

# Firewall policy for VPN traffic
resource "fortios_firewall_policy" "vpn_policy" {
  policyid = 10
  name     = "aws-vpn-policy"
  action   = "accept"
  
  srcintf {
    name = "internal"
  }
  
  dstintf {
    name = fortios_vpnipsec_phase1interface.aws_tunnel.name
  }
  
  srcaddr {
    name = "all"
  }
  
  dstaddr {
    name = "all"
  }
  
  service {
    name = "ALL"
  }
  
  schedule = "always"
}
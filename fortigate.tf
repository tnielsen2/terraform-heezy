# FortiGate Configuration
# This file contains all FortiGate-related resources
# Rename to fortigate.tf.disabled when AWS resources are disabled

# FortiGate credentials from AWS Secrets Manager - always fetch for auth
data "aws_secretsmanager_secret_version" "fortigate" {
  secret_id = "production/heezy/terraform/fortigate/secret"
}

locals {
  fortigate_creds = jsondecode(data.aws_secretsmanager_secret_version.fortigate.secret_string)
}

# FortiGate provider configuration
provider "fortios" {
  hostname = "192.168.1.1:8443"
  username = local.fortigate_creds.username
  password = local.fortigate_creds.password
  insecure = "true"
}

# AWS Zone for tunnel interface
resource "fortios_system_zone" "aws" {
  count = local.enable_aws_resources ? 1 : 0

  name      = "AWS"
  intrazone = "deny"
  interface {
    interface_name = fortios_vpnipsec_phase1interface.aws_tunnel[0].name
  }
}

# Update existing zones to default deny
resource "fortios_system_zone" "servers_update" {
  count = local.enable_aws_resources ? 1 : 0

  name      = "SERVERS"
  intrazone = "deny"
  interface {
    interface_name = "internal7"
  }
}

resource "fortios_system_zone" "users_update" {
  count = local.enable_aws_resources ? 1 : 0

  name      = "USERS"
  intrazone = "deny"
  interface {
    interface_name = "FGT-Switch"
  }
}

# Address objects for networks
resource "fortios_firewall_address" "servers" {
  count = local.enable_aws_resources ? 1 : 0

  name   = "SERVERS_NET"
  subnet = "192.168.1.0 255.255.255.0"
}

resource "fortios_firewall_address" "users" {
  count = local.enable_aws_resources ? 1 : 0

  name   = "USERS_NET"
  subnet = "192.168.2.0 255.255.255.0"
}

resource "fortios_firewall_address" "k8s" {
  count = local.enable_aws_resources ? 1 : 0

  name   = "K8S_NET"
  subnet = "192.168.10.0 255.255.255.0"
}

resource "fortios_firewall_address" "onprem_summary" {
  count = local.enable_aws_resources ? 1 : 0

  name   = "ONPREM_SUMMARY"
  subnet = "192.168.0.0 255.255.0.0"
}

resource "fortios_firewall_address" "aws_vpc" {
  count = local.enable_aws_resources ? 1 : 0

  name   = "AWS_VPC"
  subnet = "10.0.0.0 255.255.0.0"
}

# IPSec Phase 1 Interface
resource "fortios_vpnipsec_phase1interface" "aws_tunnel" {
  count = local.enable_aws_resources ? 1 : 0

  name              = "aws-tunnel"
  interface         = "wan1"
  peertype          = "any"
  proposal          = "aes256-sha256"
  dhgrp             = "14"
  remote_gw         = aws_vpn_connection.main[0].tunnel1_address
  psksecret         = aws_vpn_connection.main[0].tunnel1_preshared_key
  dpd_retrycount    = 3
  dpd_retryinterval = 60
}

# IPSec Phase 2 Interface
resource "fortios_vpnipsec_phase2interface" "aws_tunnel" {
  count = local.enable_aws_resources ? 1 : 0

  name       = "aws-tunnel"
  phase1name = fortios_vpnipsec_phase1interface.aws_tunnel[0].name
  proposal   = "aes256-sha256"
  dhgrp      = "14"
  src_subnet = "0.0.0.0/0"
  dst_subnet = "0.0.0.0/0"
}

# BGP Configuration
resource "fortios_router_bgp" "main" {
  count = local.enable_aws_resources ? 1 : 0

  as        = 65002
  router_id = "192.168.1.1"
}

resource "fortios_routerbgp_neighbor" "aws" {
  count = local.enable_aws_resources ? 1 : 0

  ip                   = aws_vpn_connection.main[0].tunnel1_cgw_inside_address
  remote_as            = 64512
  soft_reconfiguration = "enable"
}

resource "fortios_routerbgp_network" "onprem" {
  count = local.enable_aws_resources ? 1 : 0

  prefix = "192.168.0.0/16"
}

# Segmented firewall policies
resource "fortios_firewall_policy" "servers_to_aws" {
  count = local.enable_aws_resources ? 1 : 0

  policyid = 10
  name     = "servers-to-aws"
  action   = "accept"

  srcintf {
    name = "SERVERS"
  }

  dstintf {
    name = "AWS"
  }

  srcaddr {
    name = fortios_firewall_address.servers[0].name
  }

  dstaddr {
    name = fortios_firewall_address.aws_vpc[0].name
  }

  service {
    name = "ALL"
  }

  schedule = "always"
}

resource "fortios_firewall_policy" "aws_to_servers" {
  count = local.enable_aws_resources ? 1 : 0

  policyid = 11
  name     = "aws-to-servers"
  action   = "accept"

  srcintf {
    name = "AWS"
  }

  dstintf {
    name = "SERVERS"
  }

  srcaddr {
    name = fortios_firewall_address.aws_vpc[0].name
  }

  dstaddr {
    name = fortios_firewall_address.servers[0].name
  }

  service {
    name = "ALL"
  }

  schedule = "always"
}

# Deny inter-zone traffic by default (explicit)
resource "fortios_firewall_policy" "deny_users_to_servers" {
  count = local.enable_aws_resources ? 1 : 0

  policyid = 20
  name     = "deny-users-to-servers"
  action   = "deny"

  srcintf {
    name = "USERS"
  }

  dstintf {
    name = "SERVERS"
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

  schedule   = "always"
  logtraffic = "all"
}
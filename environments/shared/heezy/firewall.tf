# Firewall Policies for Shared Environment

# Outbound policy: SHARED to WAN
resource "fortios_firewall_policy" "shared_to_wan" {
  policyid = 300
  name     = "shared-to-wan"
  action   = "accept"

  srcintf {
    name = "SHARED"
  }

  dstintf {
    name = "WAN"
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
  nat      = "enable"
}


resource "fortios_firewall_policy" "allow_heezy_users_fw_mgmt" {
  policyid = 301
  name     = "allow-heezy-users-fw-mgmt"
  action   = "accept"

  srcintf {
    name = "USERS"
  }

  dstintf {
    name = "SHARED"
  }

  srcaddr {
    name = "heezy-users-192.168.2.0-24"
  }

  dstaddr {
    name = "fortigate-shared-mgmt"
  }

  service {
    name = "TCP/8443"
  }

  schedule = "always"
  nat      = "disable"
}


resource "fortios_firewall_policy" "allow_heezy_users_to_dnsmasq" {
  policyid = 309
  name     = "allow-users-to-shared-dnsmasq"
  action   = "accept"

  srcintf {
    name = "USERS"
  }

  dstintf {
    name = "SHARED"
  }

  srcaddr {
    name = "heezy-users-192.168.2.0-24"
  }

  dstaddr {
    name = "shared-dnsmasq"
  }

  service {
    name = "UDP/53"
  }

  schedule = "always"
  nat      = "disable"
}

resource "fortios_firewall_policy" "allow_github_runner_to_dmz" {
  policyid = 310
  name     = "allow-github-runner-to-dmz-hosts"
  action   = "accept"

  srcintf {
    name = "SHARED"
  }

  dstintf {
    name = "DMZ"
  }

  srcaddr {
    name = "shared-github-runner"
  }

  dstaddr {
    name = "heezy-dmz-192.168.3.0-24"
  }

  service {
    name = "TCP/22"
  }

  schedule = "always"
  nat      = "disable"
}


resource "fortios_firewall_policy" "allow_heezy_admin_to_prod_nebula" {
  policyid = 311
  name     = "allow-admin-to-prod-nebula"
  action   = "accept"

  srcintf {
    name = "USERS"
  }

  dstintf {
    name = "SHARED"
  }

  srcaddr {
    name = "macbook-m4-admin"
  }

  dstaddr {
    name = "nebula-microk8-nodes"
  }

  service {
    name = "ALL"
  }

  schedule = "always"
  nat      = "disable"
}

resource "fortios_firewall_policy" "allow_admin_to_dmz" {
  policyid = 312
  name     = "allow-admin-to-dmz"
  action   = "accept"

  srcintf {
    name = "USERS"
  }

  dstintf {
    name = "DMZ"
  }

  srcaddr {
    name = "macbook-m4-admin"
  }

  dstaddr {
    name = "all"
  }

  service {
    name = "ALL"
  }

  schedule = "always"
  nat      = "disable"
}

resource "fortios_firewall_policy" "allow_admin_to_shared" {
  policyid = 313
  name     = "allow-admin-to-shared"
  action   = "accept"

  srcintf {
    name = "USERS"
  }

  dstintf {
    name = "SHARED"
  }

  srcaddr {
    name = "macbook-m4-admin"
  }

  dstaddr {
    name = "all"
  }

  service {
    name = "ALL"
  }

  schedule = "always"
  nat      = "disable"
}


resource "fortios_logsyslogd_setting" "syslog_primary" {
  status                = "enable"
  server                = "192.168.1.10"
  enc_algorithm         = "disable"
  facility              = "local7"
  format                = "default"
  mode                  = "udp"
  port                  = 514
  ssl_min_proto_version = "default"
  syslog_type           = 1
}

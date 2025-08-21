# Firewall Policies for Shared Environment

# Outbound policy: PROD to WAN
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



resource "fortios_firewall_policy" "allow_github_runner_shared_fw_mgmt3" {
  policyid = 308
  name     = "allow-github-runner-shared-fw-mgmt3"
  action   = "accept"

  srcintf {
    name = "PROD"
  }

  dstintf {
    name = "SHARED"
  }

  srcaddr {
    name = "shared-github-runner"
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

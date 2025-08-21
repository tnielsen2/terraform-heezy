# Firewall Policies for Production Environment

# Outbound policy: PROD to WAN
resource "fortios_firewall_policy" "prod_to_wan" {
  policyid = 200
  name     = "prod-to-wan"
  action   = "accept"

  srcintf {
    name = "PROD"
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

# Allow github-runner to SHARED
resource "fortios_firewall_policy" "allow_github_runner" {
  policyid = 203
  name     = "allow-github-runner-mgmt-shared"
  action   = "accept"

  srcintf {
    name = "PROD"
  }

  dstintf {
    name = "SHARED"
  }

  srcaddr {
    name = "prod-github-runner"
  }

  dstaddr {
    name = "all"
  }

  service {
    name = "TCP/22"
  }

  service {
    name = "TCP/8006"
  }

  schedule = "always"
  nat      = "disable"
}

resource "fortios_firewall_policy" "allow_github_runner_fw_mgmt" {
  policyid = 204
  name     = "allow-github-runner-shared-fw-mgmt"
  action   = "accept"

  srcintf {
    name = "PROD"
  }

  dstintf {
    name = "SHARED"
  }

  srcaddr {
    name = "prod-github-runner"
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

resource "fortios_firewall_policy" "allow_github_runner_shared_fw_mgmt" {
  policyid = 206
  name     = "allow-github-runner-shared-fw-mgmt2"
  action   = "accept"

  srcintf {
    name = "PROD"
  }

  dstintf {
    name = "SHARED"
  }

  srcaddr {
    name = "prod-github-runner"
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

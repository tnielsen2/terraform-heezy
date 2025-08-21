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

# Allow github-runner to SERVERS
resource "fortios_firewall_policy" "allow_github_runner" {
  policyid = 201
  name     = "allow-github-runner-mgmt"
  action   = "accept"

  srcintf {
    name = "PROD"
  }

  dstintf {
    name = "SERVERS"
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

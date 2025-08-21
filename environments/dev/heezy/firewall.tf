# Firewall Policies for Dev Environment

# Outbound policy: DEV to WAN
resource "fortios_firewall_policy" "dev_to_wan" {
  policyid = 100
  name     = "dev-to-wan"
  action   = "accept"

  srcintf {
    name = "DEV"
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

# Firewall Policies for Production Environment

# Outbound policy: PROD to WAN
resource "fortios_firewall_policy" "prod_to_wan" {
  policyid = 100
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

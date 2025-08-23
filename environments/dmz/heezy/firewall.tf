# DMZ Firewall Policies

# DMZ outbound traffic policy
resource "fortios_firewall_policy" "dmz_outbound" {
  policyid = 11
  name     = "Permit DMZ outbound"
  srcintf {
    name = "DMZ"
  }
  dstintf {
    name = "WAN"
  }
  action = "accept"
  srcaddr {
    name = "all"
  }
  dstaddr {
    name = "all"
  }
  schedule = "always"
  service {
    name = "ALL"
  }
  logtraffic = "all"
  nat        = "enable"
}

# Minecraft remote access policy
resource "fortios_firewall_policy" "minecraft_remote_access" {
  policyid = 15
  name     = "minecraft-remote-access"
  srcintf {
    name = "WAN"
  }
  dstintf {
    name = "DMZ"
  }
  action = "accept"
  srcaddr {
    name = "all"
  }
  dstaddr {
    name = "68.55.23.111-minecraft"
  }
  schedule = "always"
  service {
    name = "minecraft-19132-udp"
  }
  inspection_mode = "proxy"
  logtraffic      = "all"

  depends_on = [fortios_firewall_address.minecraft_server]
}

# Minecraft survival remote access policy
resource "fortios_firewall_policy" "minecraft_survival_remote_access" {
  policyid = 18
  name     = "minecraft-remote-access-survival"
  srcintf {
    name = "WAN"
  }
  dstintf {
    name = "DMZ"
  }
  action = "accept"
  srcaddr {
    name = "all"
  }
  dstaddr {
    name = "68.55.23.111-minecraft-survival"
  }
  schedule = "always"
  service {
    name = "minecraft-19133-udp"
  }
  inspection_mode = "proxy"
  logtraffic      = "all"

  depends_on = [fortios_firewall_address.minecraft_survival_server]
}
# DMZ Firewall Objects

# VIP objects for minecraft servers
resource "fortios_firewall_vip" "minecraft_server" {
  name  = "68.55.23.111-minecraft"
  extip = "68.55.23.111"
  mappedip {
    range = "192.168.3.12"
  }
  extport    = "19132"
  mappedport = "19132"
  protocol   = "udp"
  comment    = "DMZ Minecraft Server"
}

resource "fortios_firewall_vip" "minecraft_survival_server" {
  name  = "68.55.23.111-minecraft-survival"
  extip = "68.55.23.111"
  mappedip {
    range = "192.168.3.12"
  }
  extport    = "19133"
  mappedport = "19133"
  protocol   = "udp"
  comment    = "DMZ Minecraft Survival Server"
}

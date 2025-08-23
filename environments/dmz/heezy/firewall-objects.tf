# DMZ Firewall Objects

# Address objects for minecraft servers
resource "fortios_firewall_address" "minecraft_server" {
  name    = "68.55.23.111-minecraft"
  type    = "ipmask"
  subnet  = "68.55.23.111/32"
  comment = "DMZ Minecraft Server"
}

resource "fortios_firewall_address" "minecraft_survival_server" {
  name    = "68.55.23.111-minecraft-survival"
  type    = "ipmask"
  subnet  = "68.55.23.111/32"
  comment = "DMZ Minecraft Survival Server"
}
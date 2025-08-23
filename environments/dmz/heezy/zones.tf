# DMZ Zone Configuration
resource "fortios_system_zone" "dmz" {
  name      = "DMZ"
  intrazone = "deny"
}
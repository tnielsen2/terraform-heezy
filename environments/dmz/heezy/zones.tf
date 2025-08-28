# DMZ Zone Configuration
resource "fortios_system_zone" "dmz" {
  name      = "DMZ"
  intrazone = "deny"

  interface {
    interface_name = "dmz"
  }
}

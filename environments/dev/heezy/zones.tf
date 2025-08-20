# FortiGate Zone Configuration
resource "fortios_system_zone" "prod" {
  name      = "DEV"
  intrazone = "allow"

  interface {
    interface_name = "DEV-vlan-1000"
  }
}

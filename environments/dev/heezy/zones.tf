# FortiGate Zone Configuration
resource "fortios_system_zone" "prod" {
  name      = "DEV"
  intrazone = "allow"

  interface {
    interface_name = "dev-vlan-1000"
  }
}

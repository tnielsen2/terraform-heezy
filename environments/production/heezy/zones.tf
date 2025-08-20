# FortiGate Zone Configuration
resource "fortios_system_zone" "prod" {
  name      = "PROD"
  intrazone = "allow"

  interface {
    interface_name = "prod-vlan-2000"
  }
}

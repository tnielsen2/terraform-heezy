# FortiGate Zone Configuration
resource "fortios_system_zone" "servers" {
  name      = "SERVERS"
  intrazone = "deny"

  interface {
    interface_name = "internal7"
  }
}

resource "fortios_system_zone" "users" {
  name      = "USERS"
  intrazone = "deny"

  interface {
    interface_name = "FGT-Switch"
  }
}

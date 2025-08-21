# FortiGate Zone Configuration
resource "fortios_system_zone" "users" {
  name      = "USERS"
  intrazone = "deny"

  interface {
    interface_name = "FGT-Switch"
  }
  interface {
    interface_name = "users-vlan-200"
  }
}

resource "fortios_system_zone" "shared" {
  name = "SHARED"

  intrazone = "deny"
  interface {
    interface_name = "internal7"
  }

}

# FortiGate Zone Configuration
resource "fortios_system_zone" "users" {
  name      = "USERS"
  intrazone = "deny"

  interface {
    interface_name = "FGT-Switch"
  }
}

resource "fortios_system_zone" "shared" {
  name = "SHARED"

  intrazone = "deny"
  interface {
    interface_name = "internal7"
  }

}

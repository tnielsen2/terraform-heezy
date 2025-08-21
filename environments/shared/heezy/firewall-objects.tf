# Shared Firewall Objects

# Service Objects
resource "fortios_firewallservice_custom" "tcp_22" {
  name = "TCP/22"

  tcp_portrange = "22"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

resource "fortios_firewallservice_custom" "tcp_8006" {
  name = "TCP/8006"

  tcp_portrange = "8006"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

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


resource "fortios_firewallservice_custom" "tcp_8443" {
  name = "TCP/8443"

  tcp_portrange = "8443"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}


# IP objects
resource "fortios_firewall_address" "fortigate_shared_mgmt" {
  name   = "fortigate-shared-mgmt"
  subnet = "192.168.1.1 255.255.255.255"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

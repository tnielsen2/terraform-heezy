resource "fortios_system_interface" "dmz" {
  name              = "dmz"
  vdom              = "root"
  ip                = "192.168.3.1 255.255.255.0"
  allowaccess       = ""
  type              = "physical"
  monitor_bandwidth = "enable"
  snmp_index        = 3

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

resource "fortios_system_interface" "internal7" {
  name              = "internal7"
  vdom              = "root"
  ip                = "192.168.1.1 255.255.255.0"
  allowaccess       = "ping https ssh http"
  type              = "physical"
  monitor_bandwidth = "enable"
  snmp_index        = 8

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

resource "fortios_system_interface" "users_vlan_200" {
  name                  = "users-vlan-200"
  vdom                  = "root"
  ip                    = "192.168.2.1 255.255.255.0"
  allowaccess           = "ping https ssh http"
  device_identification = "enable"
  role                  = "lan"
  snmp_index            = 9
  interface             = "internal7"
  vlanid                = 200

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}


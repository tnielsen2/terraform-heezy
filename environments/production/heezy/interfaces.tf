resource "fortios_system_interface" "dev_vlan_1000" {
  name                  = "prod-vlan-2000"
  vdom                  = "root"
  ip                    = "192.168.200.1 255.255.255.0"
  allowaccess           = "ping https ssh http"
  device_identification = "enable"
  role                  = "lan"
  snmp_index            = 9
  interface             = "internal7"
  vlanid                = 2000

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

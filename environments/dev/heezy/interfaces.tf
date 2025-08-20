resource "fortios_system_interface" "dev_vlan_1000" {
  name                  = "dev-vlan-1000"
  vdom                  = "root"
  ip                    = "192.168.100.1 255.255.255.0"
  allowaccess           = "ping https ssh http"
  device_identification = "enable"
  role                  = "lan"
  interface             = "internal7"
  vlanid                = 1000

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

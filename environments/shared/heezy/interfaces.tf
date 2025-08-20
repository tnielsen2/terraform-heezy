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

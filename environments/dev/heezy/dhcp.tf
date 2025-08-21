# DHCP Server Configuration for Dev VLAN

resource "fortios_systemdhcp_server" "dev_vlan_1000" {
  fosid           = 10
  interface       = "dev-vlan-1000"
  status          = "enable"
  lease_time      = 604800
  default_gateway = "192.168.100.1"
  netmask         = "255.255.255.0"
  dns_service     = "specify"
  dns_server1     = "192.168.100.1"
  dns_server2     = "8.8.8.8"

  ip_range {
    id       = 1
    start_ip = "192.168.100.2"
    end_ip   = "192.168.100.254"
  }

  depends_on = [fortios_system_interface.dev_vlan_1000]
}

# DHCP Server Configuration for Production VLAN

resource "fortios_systemdhcp_server" "prod_vlan_2000" {
  fosid           = 20
  interface       = "prod-vlan-2000"
  status          = "enable"
  lease_time      = 604800
  default_gateway = "192.168.200.1"
  netmask         = "255.255.255.0"
  dns_service     = "specify"
  dns_server1     = "192.168.200.1"
  dns_server2     = "8.8.8.8"

  ip_range {
    id       = 1
    start_ip = "192.168.200.2"
    end_ip   = "192.168.200.254"
  }
  # github-runner
  reserved_address {
    id     = 1
    ip     = "192.168.200.2"
    mac    = "bc:24:11:2d:dd:22"
    action = "assign"
  }

  depends_on = [fortios_system_interface.prod_vlan_2000]
}

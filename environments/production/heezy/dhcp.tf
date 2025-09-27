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
  # Talos 1
  reserved_address {
    id     = 1
    ip     = "192.168.1.15"
    mac    = "6c:4b:90:53:4b:61"
    action = "assign"
  }
  # Talos 2
  reserved_address {
    id     = 1
    ip     = "192.168.1.16"
    mac    = "6c:4b:90:2b:9a:9c"
    action = "assign"
  }
  # Talos 3
  reserved_address {
    id     = 1
    ip     = "192.168.1.17"
    mac    = "6c:4b:90:18:e5:d1"
    action = "assign"
  }
  # Talos 4
  reserved_address {
    id     = 1
    ip     = "192.168.1.18"
    mac    = "6c:4b:90:54:67:5e"
    action = "assign"
  }

  # Talos 5
  reserved_address {
    id     = 1
    ip     = "192.168.1.19"
    mac    = "6c:4b:90:55:a5:e4"
    action = "assign"
  }



  depends_on = [fortios_system_interface.prod_vlan_2000]
}

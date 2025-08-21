# DHCP Server Configuration for Shared Network (192.168.1.0/24)

resource "fortios_systemdhcp_server" "shared_internal7" {
  fosid           = 2
  interface       = "internal7"
  status          = "enable"
  lease_time      = 86400
  default_gateway = "192.168.1.1"
  netmask         = "255.255.255.0"
  dns_service     = "default"

  ip_range {
    id       = 1
    start_ip = "192.168.1.10"
    end_ip   = "192.168.1.200"
  }

  reserved_address {
    id     = 1
    ip     = "192.168.1.31"
    mac    = "d4:be:d9:f2:2b:43"
    action = "reserved"
  }

  reserved_address {
    id     = 2
    ip     = "192.168.1.12"
    mac    = "00:24:e8:63:5e:6f"
    action = "reserved"
  }

  reserved_address {
    id     = 3
    ip     = "192.168.1.11"
    mac    = "00:24:e8:63:5e:77"
    action = "reserved"
  }

  reserved_address {
    id     = 4
    ip     = "192.168.1.13"
    mac    = "00:50:56:bf:da:36"
    action = "reserved"
  }

  reserved_address {
    id          = 5
    ip          = "192.168.1.14"
    mac         = "bc:24:11:77:fa:ca"
    action      = "reserved"
    description = "ubuntu management box"
  }

  reserved_address {
    id          = 6
    ip          = "192.168.1.10"
    mac         = "00:50:56:bf:83:5f"
    action      = "reserved"
    description = "possible 2012r2 server on 710"
  }

  reserved_address {
    id     = 7
    ip     = "192.168.1.16"
    mac    = "00:0c:29:d0:64:3b"
    action = "reserved"
  }

  reserved_address {
    id     = 8
    ip     = "192.168.1.18"
    mac    = "00:0c:29:67:91:ad"
    action = "reserved"
  }

  reserved_address {
    id     = 9
    ip     = "192.168.1.21"
    mac    = "0c:c4:7a:15:99:80"
    action = "reserved"
  }

  reserved_address {
    id     = 10
    ip     = "192.168.1.17"
    mac    = "b8:27:eb:49:34:9b"
    action = "reserved"
  }

  reserved_address {
    id     = 11
    ip     = "192.168.1.24"
    mac    = "bc:24:11:7d:86:30"
    action = "reserved"
  }

  reserved_address {
    id     = 12
    ip     = "192.168.1.23"
    mac    = "bc:24:11:87:6b:6b"
    action = "reserved"
  }

  reserved_address {
    id     = 13
    ip     = "192.168.1.22"
    mac    = "bc:24:11:0d:a8:d0"
    action = "reserved"
  }

  reserved_address {
    id     = 14
    ip     = "192.168.1.25"
    mac    = "bc:24:11:d3:87:c1"
    action = "reserved"
  }

  reserved_address {
    id     = 15
    ip     = "192.168.1.19"
    mac    = "bc:24:11:75:fc:54"
    action = "reserved"
  }

  reserved_address {
    id     = 16
    ip     = "192.168.1.26"
    mac    = "00:26:98:a6:59:40"
    action = "reserved"
  }

  reserved_address {
    id     = 17
    ip     = "192.168.1.27"
    mac    = "bc:24:11:50:57:7c"
    action = "reserved"
  }

  reserved_address {
    id     = 18
    ip     = "192.168.1.28"
    mac    = "bc:24:11:1b:ae:38"
    action = "reserved"
  }

  depends_on = [fortios_system_interface.internal7]
}

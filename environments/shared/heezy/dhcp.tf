# DHCP Server Configuration for Shared Network (192.168.1.0/24)

resource "fortios_systemdhcp_server" "shared_internal7_dhcp" {
  fosid           = 6
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

  # PXE Boot Configuration
  next_server = "192.168.1.28"
  filename    = "ipxe.efi"

  # HTTP Boot Configuration for HTTPClient vendor class
  options {
    id    = 1
    code  = 60 # Vendor Class Identifier
    type  = "string"
    value = "HTTPClient"
  }

  options {
    id    = 2
    code  = 67 # Boot File Name (HTTP URL for HTTPClient)
    type  = "string"
    value = "http://192.168.1.28:8080/ipxe.efi"
  }

  reserved_address {
    id          = 5
    ip          = "192.168.1.14"
    mac         = "bc:24:11:77:fa:ca"
    action      = "reserved"
    description = "heezy-docker - legacy manually managed server"
  }

  reserved_address {
    id          = 9
    ip          = "192.168.1.21"
    mac         = "0c:c4:7a:15:99:80"
    action      = "reserved"
    description = "big-boi - plex/steam headless"
  }

  reserved_address {
    id          = 12
    ip          = "192.168.1.23"
    mac         = "bc:24:11:87:6b:6b"
    action      = "reserved"
    description = "unknown"
  }

  reserved_address {
    id          = 16
    ip          = "192.168.1.26"
    mac         = "00:26:98:a6:59:40"
    action      = "reserved"
    description = "unknown"
  }

  reserved_address {
    id          = 18
    ip          = "192.168.1.28"
    mac         = "bc:24:11:1b:ae:38"
    action      = "reserved"
    description = "shared-pxe"
  }

  reserved_address {
    id          = 19
    ip          = "192.168.1.29"
    mac         = "bc:24:11:a8:66:89"
    action      = "reserved"
    description = "shared-dnsmasq"
  }

  reserved_address {
    id          = 20
    ip          = "192.168.1.10"
    mac         = "bc:24:11:8c:f6:13"
    action      = "reserved"
    description = "shared-lgtm"
  }

  reserved_address {
    id          = 21
    ip          = "192.168.1.11"
    mac         = "bc:24:11:dc:93:00"
    action      = "reserved"
    description = "shared-lgtm"
  }

  depends_on = [fortios_system_interface.internal7]
}


resource "fortios_systemdhcp_server" "shared_users_vlan_200_dhcp" {
  fosid           = 5
  interface       = "users-vlan-200"
  status          = "enable"
  lease_time      = 86400
  default_gateway = "192.168.2.1"
  netmask         = "255.255.255.0"
  dns_service     = "default"

  ip_range {
    id       = 1
    start_ip = "192.168.2.2"
    end_ip   = "192.168.2.254"
  }

  reserved_address {
    id     = 1
    ip     = "192.168.2.51"
    mac    = "16:e4:a8:7f:12:aa"
    action = "reserved"
  }

  reserved_address {
    id     = 2
    ip     = "192.168.2.21"
    mac    = "00:23:05:3b:ca:c1"
    action = "reserved"
  }

  reserved_address {
    id     = 3
    ip     = "192.168.2.20"
    mac    = "38:f9:d3:e6:65:1a"
    action = "reserved"
  }

  reserved_address {
    id          = 4
    ip          = "192.168.2.16"
    mac         = "64:6e:69:4b:5e:c2"
    action      = "reserved"
    description = "Printer"
  }

  reserved_address {
    id          = 5
    ip          = "192.168.2.17"
    mac         = "e0:3f:49:11:11:bd"
    action      = "reserved"
    description = "Gaming Desktop"
  }

  reserved_address {
    id          = 6
    ip          = "192.168.2.34"
    mac         = "04:d4:c4:4d:ad:b3"
    action      = "reserved"
    description = "RyzenPC"
  }

  reserved_address {
    id     = 7
    ip     = "192.168.2.27"
    mac    = "00:50:b6:88:2b:43"
    action = "reserved"
  }

  reserved_address {
    id          = 8
    ip          = "192.168.2.31"
    mac         = "34:e1:d1:80:3d:a9"
    action      = "reserved"
    description = "hubitat"
  }

  reserved_address {
    id          = 9
    ip          = "192.168.2.3"
    mac         = "f4:d4:88:69:e8:9a"
    action      = "reserved"
    description = "trashbook m1"
  }

  reserved_address {
    id     = 10
    ip     = "192.168.2.49"
    mac    = "00:50:b6:8f:dd:1a"
    action = "reserved"
  }

  reserved_address {
    id     = 11
    ip     = "192.168.2.55"
    mac    = "80:91:33:7e:74:99"
    action = "reserved"
  }

  reserved_address {
    id     = 12
    ip     = "192.168.2.40"
    mac    = "22:8f:7b:80:d7:77"
    action = "reserved"
  }

  reserved_address {
    id     = 13
    ip     = "192.168.2.18"
    mac    = "18:b4:30:dd:37:df"
    action = "reserved"
  }

  reserved_address {
    id     = 14
    ip     = "192.168.2.12"
    mac    = "64:16:66:6b:28:56"
    action = "reserved"
  }

  reserved_address {
    id     = 15
    ip     = "192.168.2.36"
    mac    = "18:b4:30:90:34:1b"
    action = "reserved"
  }

  reserved_address {
    id     = 16
    ip     = "192.168.2.14"
    mac    = "18:b4:30:94:a3:88"
    action = "reserved"
  }

  reserved_address {
    id     = 17
    ip     = "192.168.2.15"
    mac    = "18:b4:30:95:42:c0"
    action = "reserved"
  }

  reserved_address {
    id          = 18
    ip          = "192.168.2.61"
    mac         = "5e:5e:c8:ae:c9:b1"
    action      = "reserved"
    description = "macbookm4-trent-wireless"
  }

  reserved_address {
    id     = 19
    ip     = "192.168.2.19"
    mac    = "16:13:07:36:93:5b"
    action = "reserved"
  }

  reserved_address {
    id          = 20
    ip          = "192.168.2.13"
    mac         = "bc:24:11:b0:f0:18"
    action      = "reserved"
    description = "shared-github-runner"
  }


  depends_on = [fortios_system_interface.users_vlan_200]
}

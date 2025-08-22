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

  # PXE Boot Options for Talos OS
  options {
    id    = 1
    code  = 66 # TFTP Server Name
    type  = "string"
    value = "192.168.1.28"
  }

  options {
    id    = 2
    code  = 67 # Bootfile Name
    type  = "string"
    value = "pxelinux.0"
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

  depends_on = [fortios_system_interface.internal7]
}

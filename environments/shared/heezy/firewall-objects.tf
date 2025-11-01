# Shared Firewall Objects

# Service Objects
resource "fortios_firewallservice_custom" "tcp_22" {
  name = "TCP/22"

  tcp_portrange = "22"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

resource "fortios_firewallservice_custom" "tcp_8006" {
  name = "TCP/8006"

  tcp_portrange = "8006"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}


resource "fortios_firewallservice_custom" "tcp_8443" {
  name = "TCP/8443"

  tcp_portrange = "8443"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

resource "fortios_firewallservice_custom" "tcp_50000" {
  name = "TCP/50000"

  tcp_portrange = "50000"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

resource "fortios_firewallservice_custom" "udp_53" {
  name = "UDP/53"

  udp_portrange = "53"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

# Import existing minecraft services
import {
  to = fortios_firewallservice_custom.minecraft_19132_udp
  id = "minecraft-19132-udp"
}

resource "fortios_firewallservice_custom" "minecraft_19132_udp" {
  name = "minecraft-19132-udp"

  udp_portrange = "19132"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

import {
  to = fortios_firewallservice_custom.minecraft_19133_udp
  id = "minecraft-19133-udp"
}

resource "fortios_firewallservice_custom" "minecraft_19133_udp" {
  name = "minecraft-19133-udp"

  udp_portrange = "19133"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}


# IP objects
resource "fortios_firewall_address" "fortigate_shared_mgmt" {
  name   = "fortigate-shared-mgmt"
  subnet = "192.168.1.1 255.255.255.255"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}


resource "fortios_firewall_address" "heezy_users" {
  name   = "heezy-users-192.168.2.0-24"
  subnet = "192.168.2.0 255.255.255.0"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

resource "fortios_firewall_address" "heezy_dmz" {
  name   = "heezy-dmz-192.168.3.0-24"
  subnet = "192.168.3.0 255.255.255.0"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

resource "fortios_firewall_address" "macbook_m4_wireless" {
  name   = "macbook-m4-wireless"
  subnet = "192.168.2.61 255.255.255.255"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

resource "fortios_firewall_address" "shared_github_runner" {
  name   = "shared-github-runner"
  subnet = "192.168.2.13 255.255.255.255"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}


resource "fortios_firewall_address" "shared_dnsmasq" {
  name   = "shared-dnsmasq"
  subnet = "192.168.1.29 255.255.255.255"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

resource "fortios_firewall_address" "nebula_one" {
  name   = "nebula-1"
  subnet = "192.168.1.15 255.255.255.255"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

resource "fortios_firewall_address" "nebula_two" {
  name   = "nebula-2"
  subnet = "192.168.1.16 255.255.255.255"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

resource "fortios_firewall_address" "nebula_three" {
  name   = "nebula-3"
  subnet = "192.168.1.17 255.255.255.255"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

resource "fortios_firewall_address" "nebula_four" {
  name   = "nebula-4"
  subnet = "192.168.1.18 255.255.255.255"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

resource "fortios_firewall_address" "nebula_five" {
  name   = "nebula-5"
  subnet = "192.168.1.19 255.255.255.255"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}



resource "fortios_firewall_addrgrp" "nebula_nodes" {
  name = "nebula-microk8-nodes"

  member {
    name = fortios_firewall_address.nebula_one.name
  }

  member {
    name = fortios_firewall_address.nebula_two.name
  }

  member {
    name = fortios_firewall_address.nebula_three.name
  }

  member {
    name = fortios_firewall_address.nebula_four.name
  }

  member {
    name = fortios_firewall_address.nebula_five.name
  }

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

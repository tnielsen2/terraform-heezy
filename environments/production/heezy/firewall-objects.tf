resource "fortios_firewall_address" "prod_github_runner" {
  name   = "prod-github-runner"
  subnet = "192.168.200.2 255.255.255.255"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

resource "fortios_firewall_address" "talos_one" {
  name   = "talos-one"
  subnet = "192.168.1.15 255.255.255.255"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

resource "fortios_firewall_address" "talos_two" {
  name   = "talos-two"
  subnet = "192.168.1.16 255.255.255.255"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

resource "fortios_firewall_address" "talos_three" {
  name   = "talos-three"
  subnet = "192.168.1.17 255.255.255.255"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

resource "fortios_firewall_address" "talos_four" {
  name   = "talos-four"
  subnet = "192.168.1.18 255.255.255.255"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

resource "fortios_firewall_address" "talos_five" {
  name   = "talos-five"
  subnet = "192.168.1.19 255.255.255.255"

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}

resource "fortios_firewall_addrgrp" "talos_nodes" {
  name = "talos-nodes"

  member {
    name = fortios_firewall_address.talos_one.name
  }

  member {
    name = fortios_firewall_address.talos_two.name
  }

  member {
    name = fortios_firewall_address.talos_three.name
  }

  member {
    name = fortios_firewall_address.talos_four.name
  }

  member {
    name = fortios_firewall_address.talos_five.name
  }

  lifecycle {
    ignore_changes = [
      dynamic_sort_subtable,
      get_all_tables
    ]
  }
}


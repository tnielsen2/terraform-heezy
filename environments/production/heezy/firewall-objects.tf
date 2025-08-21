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

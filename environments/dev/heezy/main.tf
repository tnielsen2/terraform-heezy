# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Proxmox credentials from AWS Secrets Manager - dev environment
data "aws_secretsmanager_secret_version" "proxmox" {
  secret_id = "production/heezy/terraform/proxmox/secret"
}

data "aws_secretsmanager_secret_version" "fortigate" {
  secret_id = "production/heezy/terraform/fortigate/secret"
}


locals {
  proxmox_creds   = jsondecode(data.aws_secretsmanager_secret_version.proxmox.secret_string)
  fortigate_creds = jsondecode(data.aws_secretsmanager_secret_version.fortigate.secret_string)
}

provider "aws" {
  region = var.region
}

provider "proxmox" {
  alias    = "proxmox_610"
  endpoint = "https://192.168.1.144:8006/"
  username = local.proxmox_creds.username
  password = local.proxmox_creds.password
  insecure = true
}

provider "proxmox" {
  endpoint = "https://192.168.1.144:8006/"
  username = local.proxmox_creds.username
  password = local.proxmox_creds.password
  insecure = true
}

# FortiGate provider configuration
provider "fortios" {
  hostname = "192.168.1.1:8443"
  username = local.fortigate_creds.username
  password = local.fortigate_creds.password
  insecure = "true"
}

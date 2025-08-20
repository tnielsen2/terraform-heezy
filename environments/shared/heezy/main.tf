# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Shared Heezy Environment - FortiGate Configuration

# Proxmox credentials from AWS Secrets Manager
data "aws_secretsmanager_secret_version" "proxmox" {
  secret_id = "production/heezy/terraform/proxmox/secret"
}

# FortiGate credentials from AWS Secrets Manager
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

provider "fortios" {
  hostname = "192.168.1.1:8443"
  username = local.fortigate_creds.username
  password = local.fortigate_creds.password
  insecure = "true"
}
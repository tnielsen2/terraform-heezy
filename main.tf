# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Proxmox credentials from AWS Secrets Manager - always fetch for auth
data "aws_secretsmanager_secret_version" "proxmox" {
  secret_id = "production/heezy/terraform/proxmox/secret"
}

locals {
  proxmox_creds = jsondecode(data.aws_secretsmanager_secret_version.proxmox.secret_string)
}

provider "aws" {
  region = var.region
}

provider "proxmox" {
  endpoint = "https://192.168.1.144:8006/"
  username = local.proxmox_creds.username
  password = local.proxmox_creds.password
  insecure = true
}
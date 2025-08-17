# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

data "aws_secretsmanager_secret_version" "proxmox" {
  secret_id = "production/terraform-proxmox/heezy/proxmox/secret"
}

locals {
  proxmox_creds = jsondecode(data.aws_secretsmanager_secret_version.proxmox.secret_string)
}

provider "aws" {
  region = var.region
}

provider "proxmox" {
  pm_api_url      = "https://192.168.1.144:8006/api2/json"
  pm_user         = local.proxmox_creds.username
  pm_password     = local.proxmox_creds.password
  pm_tls_insecure = true
}

terraform {
  backend "s3" {
    bucket         = "terraform-proxmox-state-backend"
    key            = "heezy/state/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-proxmox-state-backend"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc4"
    }
    fortios = {
      source  = "fortinetdev/fortios"
      version = "~> 1.20"
    }
  }
}

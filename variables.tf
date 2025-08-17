# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  type        = string
  description = "Default AWS Region"
  default     = "us-east-2"
}

variable "project_name" {
  type        = string
  description = "Heezy Proxmox VM Provisioning"
  default     = "terraform-proxmox"
}

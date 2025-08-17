locals {
  # Feature toggles
  enable_aws_resources = false # Set to true to enable AWS resources

  common_tags = {
    service = "heezy"
    project = "terraform-proxmox"
  }
}
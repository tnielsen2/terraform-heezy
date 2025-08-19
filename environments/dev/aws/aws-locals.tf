locals {
  # AWS Environment Configuration
  enable_aws_resources = false # Set to true to enable AWS resources

  common_tags = {
    service     = "heezy"
    project     = "heezy-infra"
    environment = "dev"
  }
}
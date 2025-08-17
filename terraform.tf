
terraform {
  backend "s3" {
    bucket       = "terraform-heezy-state"
    key          = "heezy/state/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
    encrypt      = true
    kms_key_id   = "755825ea-0113-4a60-90c9-1f79d49d7079"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    proxmox = {
      source = "telmate/proxmox"
    }
    fortios = {
      source  = "fortinetdev/fortios"
      version = "~> 1.20"
    }
  }
}

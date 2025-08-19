terraform {
  backend "s3" {
    bucket       = "terraform-heezy-state"
    key          = "dev/heezy/terraform.tfstate"
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
      source  = "bpg/proxmox"
      version = "0.81.0"
    }
    fortios = {
      source  = "fortinetdev/fortios"
      version = "~> 1.20"
    }
  }
}
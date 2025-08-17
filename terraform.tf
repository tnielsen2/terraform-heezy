
terraform {
  backend "s3" {
    bucket       = "terraform-proxmox-state-backend"
    key          = "heezy/state/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
    encrypt      = true
    kms_key_id   = "ccb44e47-6677-4417-a89d-a305d85a3bdf"
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

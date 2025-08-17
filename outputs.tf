# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "windows_vms" {
  description = "Windows VM information"
  value = {
    vm1 = {
      id   = module.windows_vm1.vm_id
      name = module.windows_vm1.vm_name
      ip   = module.windows_vm1.vm_ip
    }

  }
}

output "linux_vms" {
  description = "Linux VM information"
  value = {
    vm1 = {
      id   = module.linux_vm1.vm_id
      name = module.linux_vm1.vm_name
      ip   = module.linux_vm1.vm_ip
    }
  }
}

# AWS outputs
output "vpc_info" {
  description = "VPC information"
  value = local.enable_aws_resources ? {
    vpc_id         = aws_vpc.main[0].id
    vpc_cidr       = aws_vpc.main[0].cidr_block
    public_subnet  = aws_subnet.public[0].id
    private_subnet = aws_subnet.private[0].id
  } : null
}

output "vpn_connection" {
  description = "VPN connection details"
  value = local.enable_aws_resources ? {
    tunnel1_address = aws_vpn_connection.main[0].tunnel1_address
    tunnel2_address = aws_vpn_connection.main[0].tunnel2_address
  } : null
  sensitive = true
}

output "ec2_instances" {
  description = "EC2 instance information"
  value = local.enable_aws_resources ? {
    web_server = {
      id         = aws_instance.web[0].id
      public_ip  = aws_instance.web[0].public_ip
      private_ip = aws_instance.web[0].private_ip
    }
    app_server = {
      id         = aws_instance.app[0].id
      private_ip = aws_instance.app[0].private_ip
    }
  } : null
}

output "rds_endpoints" {
  description = "RDS database endpoints"
  value = local.enable_aws_resources ? {
    mysql_endpoint    = aws_db_instance.main[0].endpoint
    postgres_endpoint = aws_db_instance.postgres[0].endpoint
  } : null
  sensitive = true
}
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
    vm2 = {
      id   = module.windows_vm2.vm_id
      name = module.windows_vm2.vm_name
      ip   = module.windows_vm2.vm_ip
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
  value = {
    vpc_id     = aws_vpc.main.id
    vpc_cidr   = aws_vpc.main.cidr_block
    public_subnet = aws_subnet.public.id
    private_subnet = aws_subnet.private.id
  }
}

output "vpn_connection" {
  description = "VPN connection details"
  value = {
    tunnel1_address = aws_vpn_connection.main.tunnel1_address
    tunnel2_address = aws_vpn_connection.main.tunnel2_address
  }
  sensitive = true
}

output "ec2_instances" {
  description = "EC2 instance information"
  value = {
    web_server = {
      id         = aws_instance.web.id
      public_ip  = aws_instance.web.public_ip
      private_ip = aws_instance.web.private_ip
    }
    app_server = {
      id         = aws_instance.app.id
      private_ip = aws_instance.app.private_ip
    }
  }
}

output "rds_endpoints" {
  description = "RDS database endpoints"
  value = {
    mysql_endpoint    = aws_db_instance.main.endpoint
    postgres_endpoint = aws_db_instance.postgres.endpoint
  }
  sensitive = true
}
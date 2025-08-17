# AWS Networking - VPCs, Cloud WAN, VPN Gateway

locals {
  common_tags = {
    service = "heezy"
    project = "terraform-proxmox"
  }
}

# Main VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = merge(local.common_tags, {
    Name = "heezy-main-vpc"
  })
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  
  tags = merge(local.common_tags, {
    Name = "heezy-public-subnet"
  })
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.region}b"
  
  tags = merge(local.common_tags, {
    Name = "heezy-private-subnet"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = merge(local.common_tags, {
    Name = "heezy-igw"
  })
}

# Customer Gateway (FortiGate)
resource "aws_customer_gateway" "fortigate" {
  bgp_asn    = 65000
  ip_address = "YOUR_PUBLIC_IP"  # Replace with your public IP
  type       = "ipsec.1"
  
  tags = merge(local.common_tags, {
    Name = "heezy-fortigate-cgw"
  })
}

# VPN Gateway
resource "aws_vpn_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = merge(local.common_tags, {
    Name = "heezy-vpn-gateway"
  })
}

# VPN Connection
resource "aws_vpn_connection" "main" {
  vpn_gateway_id      = aws_vpn_gateway.main.id
  customer_gateway_id = aws_customer_gateway.fortigate.id
  type                = "ipsec.1"
  static_routes_only  = true
  
  tags = merge(local.common_tags, {
    Name = "heezy-vpn-connection"
  })
}

# VPN Connection Route
resource "aws_vpn_connection_route" "on_premises" {
  vpn_connection_id      = aws_vpn_connection.main.id
  destination_cidr_block = "192.168.1.0/24"
}

# Cloud WAN Core Network
resource "aws_networkmanager_core_network" "main" {
  global_network_id = aws_networkmanager_global_network.main.id
  policy_document   = jsonencode({
    version = "2021.12"
    core-network-configuration = {
      asn-ranges = ["64512-65534"]
      edge-locations = [
        {
          location = var.region
          asn      = 64512
        }
      ]
    }
    segments = [
      {
        name                          = "shared"
        description                   = "Shared segment"
        require-attachment-acceptance = false
      }
    ]
  })
  
  tags = merge(local.common_tags, {
    Name = "heezy-core-network"
  })
}

# Global Network
resource "aws_networkmanager_global_network" "main" {
  description = "Heezy Global Network"
  
  tags = merge(local.common_tags, {
    Name = "heezy-global-network"
  })
}

# VPC Attachment to Cloud WAN
resource "aws_networkmanager_vpc_attachment" "main" {
  core_network_id = aws_networkmanager_core_network.main.id
  vpc_arn         = aws_vpc.main.arn
  subnet_arns     = [aws_subnet.private.arn]
  
  tags = merge(local.common_tags, {
    Name = "heezy-vpc-attachment"
  })
}
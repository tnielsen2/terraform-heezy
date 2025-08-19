# AWS Networking - VPCs, Cloud WAN, VPN Gateway

# Main VPC
resource "aws_vpc" "main" {
  count = local.enable_aws_resources ? 1 : 0

  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = "heezy-main-vpc"
  })
}

# Public Subnet
resource "aws_subnet" "public" {
  count = local.enable_aws_resources ? 1 : 0

  vpc_id                  = aws_vpc.main[0].id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "heezy-public-subnet"
  })
}

# Private Subnet
resource "aws_subnet" "private" {
  count = local.enable_aws_resources ? 1 : 0

  vpc_id            = aws_vpc.main[0].id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.region}b"

  tags = merge(local.common_tags, {
    Name = "heezy-private-subnet"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  count = local.enable_aws_resources ? 1 : 0

  vpc_id = aws_vpc.main[0].id

  tags = merge(local.common_tags, {
    Name = "heezy-igw"
  })
}

# Customer Gateway (FortiGate)
resource "aws_customer_gateway" "fortigate" {
  count = local.enable_aws_resources ? 1 : 0

  bgp_asn    = 65002
  ip_address = "68.55.23.111"
  type       = "ipsec.1"

  tags = merge(local.common_tags, {
    Name = "heezy-fortigate-cgw"
  })
}

# VPN Gateway
resource "aws_vpn_gateway" "main" {
  count = local.enable_aws_resources ? 1 : 0

  vpc_id = aws_vpc.main[0].id

  tags = merge(local.common_tags, {
    Name = "heezy-vpn-gateway"
  })
}

# VPN Connection with BGP
resource "aws_vpn_connection" "main" {
  count = local.enable_aws_resources ? 1 : 0

  vpn_gateway_id      = aws_vpn_gateway.main[0].id
  customer_gateway_id = aws_customer_gateway.fortigate[0].id
  type                = "ipsec.1"
  static_routes_only  = false

  tags = merge(local.common_tags, {
    Name = "heezy-vpn-connection"
  })
}

# Cloud WAN Core Network
resource "aws_networkmanager_core_network" "main" {
  count = local.enable_aws_resources ? 1 : 0

  global_network_id = aws_networkmanager_global_network.main[0].id

  tags = merge(local.common_tags, {
    Name = "heezy-core-network"
  })
}

# Global Network
resource "aws_networkmanager_global_network" "main" {
  count = local.enable_aws_resources ? 1 : 0

  description = "Heezy Global Network"

  tags = merge(local.common_tags, {
    Name = "heezy-global-network"
  })
}

# VPC Attachment to Cloud WAN
resource "aws_networkmanager_vpc_attachment" "main" {
  count = local.enable_aws_resources ? 1 : 0

  core_network_id = aws_networkmanager_core_network.main[0].id
  vpc_arn         = aws_vpc.main[0].arn
  subnet_arns     = [aws_subnet.private[0].arn]

  tags = merge(local.common_tags, {
    Name = "heezy-vpc-attachment"
  })
}
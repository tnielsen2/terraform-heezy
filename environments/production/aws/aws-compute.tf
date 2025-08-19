# AWS Compute - EC2 instances

# Security Group for EC2 instances
resource "aws_security_group" "ec2" {
  count = local.enable_aws_resources ? 1 : 0

  name_prefix = "heezy-ec2-"
  vpc_id      = aws_vpc.main[0].id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.1.0/24", "10.0.0.0/16"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["192.168.1.0/24", "10.0.0.0/16"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["192.168.1.0/24", "10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "heezy-ec2-sg"
  })
}

# Key Pair for EC2 instances
resource "aws_key_pair" "main" {
  count = local.enable_aws_resources ? 1 : 0

  key_name   = "heezy-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2E..." # Replace with your public key

  tags = local.common_tags
}

# EC2 Instance in Public Subnet
resource "aws_instance" "web" {
  count = local.enable_aws_resources ? 1 : 0

  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.main[0].key_name
  vpc_security_group_ids = [aws_security_group.ec2[0].id]
  subnet_id              = aws_subnet.public[0].id

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Heezy Web Server</h1>" > /var/www/html/index.html
  EOF

  tags = merge(local.common_tags, {
    Name = "heezy-web-server"
  })
}

# EC2 Instance in Private Subnet
resource "aws_instance" "app" {
  count = local.enable_aws_resources ? 1 : 0

  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.main[0].key_name
  vpc_security_group_ids = [aws_security_group.ec2[0].id]
  subnet_id              = aws_subnet.private[0].id

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y docker
    systemctl start docker
    systemctl enable docker
  EOF

  tags = merge(local.common_tags, {
    Name = "heezy-app-server"
  })
}
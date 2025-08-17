# AWS Database - RDS instances

# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "heezy-db-subnet-group"
  subnet_ids = [aws_subnet.private.id, aws_subnet.public.id]
  
  tags = merge(local.common_tags, {
    Name = "heezy-db-subnet-group"
  })
}

# Security Group for RDS
resource "aws_security_group" "rds" {
  name_prefix = "heezy-rds-"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
    cidr_blocks     = ["192.168.1.0/24"]
  }
  
  tags = merge(local.common_tags, {
    Name = "heezy-rds-sg"
  })
}

# RDS MySQL Instance
resource "aws_db_instance" "main" {
  identifier     = "heezy-mysql"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp2"
  storage_encrypted     = true
  
  db_name  = "heezydb"
  username = "admin"
  password = "changeme123!"  # Use AWS Secrets Manager in production
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  skip_final_snapshot = true
  deletion_protection = false
  
  tags = merge(local.common_tags, {
    Name = "heezy-mysql-db"
  })
}

# RDS PostgreSQL Instance
resource "aws_db_instance" "postgres" {
  identifier     = "heezy-postgres"
  engine         = "postgres"
  engine_version = "15.4"
  instance_class = "db.t3.micro"
  
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp2"
  storage_encrypted     = true
  
  db_name  = "heezydb"
  username = "postgres"
  password = "changeme123!"  # Use AWS Secrets Manager in production
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  skip_final_snapshot = true
  deletion_protection = false
  
  tags = merge(local.common_tags, {
    Name = "heezy-postgres-db"
  })
}
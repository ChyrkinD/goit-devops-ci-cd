# Subnet Group, спільна для Aurora та RDS
resource "aws_db_subnet_group" "this" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.db_name}-subnet-group"
  }
}

# Security Group, спільна для Aurora та RDS
resource "aws_security_group" "this" {
  name        = "${var.db_name}-sg"
  description = "Security Group for ${var.db_name}"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow DB access from allowed CIDRs"
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.db_name}-sg"
  }
}

# Parameter Group для звичайного RDS
resource "aws_db_parameter_group" "rds" {
  count  = var.use_aurora ? 0 : 1
  name   = "${var.db_name}-rds-pg"
  family = "postgres15" # Залежить від engine_version, припускаємо postgres15

  parameter {
    name         = "max_connections"
    value        = "100"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "log_statement"
    value = "all"
  }

  parameter {
    name  = "work_mem"
    value = "4096"
  }
}

# Parameter Group для Aurora Cluster
resource "aws_rds_cluster_parameter_group" "aurora" {
  count  = var.use_aurora ? 1 : 0
  name   = "${var.db_name}-aurora-pg"
  family = "aurora-postgresql15" # Залежить від engine_version, припускаємо aurora-postgresql15

  parameter {
    name  = "max_connections"
    value = "100"
  }

  parameter {
    name  = "log_statement"
    value = "all"
  }

  parameter {
    name  = "work_mem"
    value = "4096"
  }
}

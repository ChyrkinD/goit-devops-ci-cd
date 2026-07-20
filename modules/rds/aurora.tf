# Створення Aurora кластера (створюється, якщо use_aurora = true)
resource "aws_rds_cluster" "this" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier = "${var.db_name}-cluster"
  engine             = var.engine
  engine_version     = var.engine_version
  database_name      = var.db_name
  master_username    = var.db_username
  master_password    = var.db_password

  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = [aws_security_group.this.id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora[0].name

  skip_final_snapshot = true
}

# Створення Writer-інстанції для Aurora кластера
resource "aws_rds_cluster_instance" "writer" {
  count = var.use_aurora ? 1 : 0

  identifier         = "${var.db_name}-writer"
  cluster_identifier = aws_rds_cluster.this[0].id
  engine             = aws_rds_cluster.this[0].engine
  engine_version     = aws_rds_cluster.this[0].engine_version
  instance_class     = var.instance_class

  db_subnet_group_name = aws_db_subnet_group.this.name
  publicly_accessible  = false
}

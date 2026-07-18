output "db_endpoint" {
  description = "Кінцева точка підключення до бази даних"
  value       = var.use_aurora ? aws_rds_cluster.this[0].endpoint : aws_db_instance.this[0].address
}

output "db_port" {
  description = "Порт бази даних"
  value       = var.use_aurora ? aws_rds_cluster.this[0].port : aws_db_instance.this[0].port
}

output "db_name" {
  description = "Ім'я бази даних"
  value       = var.use_aurora ? aws_rds_cluster.this[0].database_name : aws_db_instance.this[0].db_name
}

output "security_group_id" {
  description = "ID створеної Security Group для бази даних"
  value       = aws_security_group.this.id
}

output "grafana_password" {
  description = "Пароль адміністратора Grafana (логін: admin)"
  value       = var.grafana_admin_password
  sensitive   = true
}

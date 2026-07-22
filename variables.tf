variable "db_password" {
  description = "Пароль для бази даних RDS"
  type        = string
  sensitive   = true
}

variable "grafana_admin_password" {
  description = "Пароль адміністратора Grafana"
  type        = string
  sensitive   = true
}

variable "jenkins_admin_password" {
  description = "Пароль адміністратора Jenkins"
  type        = string
  sensitive   = true
}

variable "git_repo_url" {
  description = "URL GitHub репозиторію для CI/CD"
  type        = string
  default     = "https://github.com/example/argocd-demo.git"
}

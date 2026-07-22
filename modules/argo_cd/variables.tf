variable "namespace" {
  description = "Kubernetes namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Helm chart version for Argo CD"
  type        = string
  default     = "5.46.7"
}

variable "git_repo_url" {
  description = "Git Repository URL"
  type        = string
}

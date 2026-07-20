variable "namespace" {
  description = "Kubernetes namespace for Jenkins"
  type        = string
  default     = "ci"
}

variable "chart_version" {
  description = "Helm chart version for Jenkins"
  type        = string
  default     = "5.0.16"
}

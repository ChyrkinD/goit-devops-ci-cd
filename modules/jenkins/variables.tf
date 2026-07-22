variable "namespace" {
  description = "Namespace where Jenkins will be installed"
  type        = string
  default     = "jenkins"
}

variable "chart_version" {
  description = "Helm chart version"
  type        = string
  default     = "4.4.2"
}

variable "jenkins_admin_password" {
  description = "Jenkins admin password"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR Repository URL"
  type        = string
}

variable "git_repo_url" {
  description = "Git Repository URL"
  type        = string
}

variable "eks_oidc_provider_arn" {
  description = "EKS OIDC Provider ARN"
  type        = string
}

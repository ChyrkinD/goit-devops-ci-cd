terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.15"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig for the EKS cluster"
  type        = string
  default     = "~/.kube/config"
}

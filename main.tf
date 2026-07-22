terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.15"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

data "aws_caller_identity" "current" {}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# Підключаємо модуль для S3 та DynamoDB
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "terraform-state-bucket-chyrkin"
  table_name  = "terraform-locks-lesson-5-chyrkin"
}

# Підключаємо модуль VPC
module "vpc" {
  source                  = "./modules/vpc"
  vpc_cidr_block          = "10.0.0.0/16"
  public_subnets          = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets         = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones      = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  vpc_name                = "lesson-5-vpc"
  endpoint_private_access = true
  endpoint_public_access  = true
}

# Підключаємо модуль ECR
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-5-ecr"
  scan_on_push = true
}

# Підключаємо модуль EKS
module "eks" {
  source                    = "./modules/eks"
  cluster_name              = "lesson-7-eks"
  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = module.vpc.private_subnets
  node_group_instance_types = ["t3.medium"]
  desired_size              = 2
  min_size                  = 2
  max_size                  = 6
  aws_region                = "eu-north-1"
}

module "jenkins" {
  source        = "./modules/jenkins"
  namespace     = "ci"
  chart_version = "5.0.16"

  jenkins_admin_password = var.jenkins_admin_password
  aws_account_id         = data.aws_caller_identity.current.account_id
  ecr_repository_url     = module.ecr.repository_url
  git_repo_url           = var.git_repo_url
  eks_oidc_provider_arn  = module.eks.oidc_provider_arn

  depends_on = [module.eks]
}

module "argo_cd" {
  source        = "./modules/argo_cd"
  namespace     = "argocd"
  chart_version = "7.8.11"

  git_repo_url = var.git_repo_url

  depends_on = [module.eks]
}

# Підключаємо універсальний модуль RDS (Приклад використання)
module "rds" {
  source = "./modules/rds"

  use_aurora  = false
  db_name     = "djangodb"
  db_username = "dbadmin"
  db_password = var.db_password

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  engine         = "postgres"
  engine_version = "15.15"
  instance_class = "db.t3.micro"

  allocated_storage   = 20
  allowed_cidr_blocks = ["10.0.0.0/16"]
}

module "monitoring" {
  source                 = "./modules/monitoring"
  grafana_admin_password = var.grafana_admin_password
  depends_on             = [module.eks]
}
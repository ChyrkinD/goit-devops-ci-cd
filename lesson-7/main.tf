terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
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
  subnet_ids                = concat(module.vpc.public_subnets, module.vpc.private_subnets)
  node_group_instance_types = ["t3.medium"]
  desired_size              = 2
  min_size                  = 2
  max_size                  = 6
  aws_region                = "eu-north-1"
}
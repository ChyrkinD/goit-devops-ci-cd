# Lesson 5 - Terraform AWS Infrastructure

This project provisions a basic AWS infrastructure using Terraform modules for:

- S3 backend for Terraform state files and DynamoDB locking
- VPC with public and private subnets
- ECR repository for container images

## Project structure

- `main.tf` - root module wiring for all child modules
- `backend.tf` - S3 backend configuration for Terraform state
- `outputs.tf` - shared outputs from the modules
- `modules/s3-backend/` - S3 bucket and DynamoDB table for state locking
- `modules/vpc/` - VPC, subnets, gateways, and route tables
- `modules/ecr/` - Elastic Container Registry repository

## Usage

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

## Module overview

- `s3-backend` creates the S3 bucket used to store Terraform state and the DynamoDB table used to lock state files.
- `vpc` creates a VPC with 3 public subnets, 3 private subnets, an Internet Gateway, and a NAT Gateway.
- `ecr` creates an ECR repository with image scanning enabled on push.

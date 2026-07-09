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

### Step 1: Bootstrap with Local Backend

The project starts with a **local backend** to avoid the bootstrap problem (you can't use S3 backend before the S3 bucket exists). Run:

```bash
terraform init
terraform plan
terraform apply
```

This creates:

- S3 bucket for state files
- DynamoDB table for state locking
- VPC with public/private subnets
- NAT Gateway for outbound traffic
- ECR repository for container images

### Step 2: Migrate to S3 Backend (Optional)

After the infrastructure is created, you can move your state to S3 for production use:

1. **Update `backend.tf`**: Uncomment the S3 backend block and comment out the local backend
2. **Reinitialize Terraform**:
   ```bash
   terraform init -migrate-state
   ```
3. **Confirm the migration** when prompted

### Destroy Infrastructure

```bash
terraform destroy
```

## Security Features

- **S3 bucket**: Encrypted with AES256, versioning enabled, public access blocked, old versions auto-expire
- **ECR repository**: Access restricted to your AWS account only, image scanning enabled, lifecycle policy removes old images
- **DynamoDB**: Prevents concurrent state modifications with locking

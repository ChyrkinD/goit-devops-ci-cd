# Lesson 7 - EKS + ECR + Helm deployment for Django

This folder contains Terraform modules and a Helm chart to deploy the Django application to an EKS cluster in the same VPC created earlier.

## What changed

- Added the EKS module to the Terraform root configuration.
- Restored the S3 backend configuration for remote Terraform state.
- Enabled private/public VPC endpoint access in the VPC module.
- Made ECR encryption explicit with AES256.
- Added CPU/memory requests and liveness/readiness/startup probes to the Helm chart.

## Requirements

- AWS CLI configured with credentials
- kubectl and helm installed
- Docker installed for building images

## Quick workflow

1. Bootstrap Terraform and create infra:

```bash
cd lesson-7
terraform init
terraform plan
terraform apply
```

2. Build and push the Django image to ECR:

```bash
./scripts/build-and-push.sh <ECR_URL> v1
```

3. Configure kubectl:

```bash
aws eks update-kubeconfig --region eu-north-1 --name $(terraform output -raw cluster_name)
```

4. Deploy the application with Helm:

```bash
helm upgrade --install django-app ./charts/django-app \
  --set image.repository=<ECR_URL> \
  --set image.tag=v1
```

## Files of interest

- main.tf - root Terraform wiring
- backend.tf - S3 backend configuration for remote state
- modules/ecr - creates the ECR repository with AES256 encryption
- modules/eks - creates the EKS cluster and managed node group
- charts/django-app - Helm chart with Deployment, Service, ConfigMap, HPA, and probes
- scripts/build-and-push.sh - helper to push the image to ECR

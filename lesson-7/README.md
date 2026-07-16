# Lesson 7 - EKS + ECR + Helm deployment for Django

This folder contains Terraform modules, Jenkins/Argo CD installation assets, and a Helm chart to deploy the Django application to an EKS cluster.

## What changed

- Added the EKS module to the Terraform root configuration.
- Restored the S3 backend configuration for remote Terraform state.
- Enabled private/public VPC endpoint access in the VPC module.
- Made ECR encryption explicit with AES256.
- Added CPU/memory requests and liveness/readiness/startup probes to the Helm chart.
- Added Terraform modules for Jenkins and Argo CD.
- Added a Jenkins pipeline definition and a simple Django container image scaffold.

## Requirements

- AWS CLI configured with credentials
- kubectl and helm installed
- Docker installed for building images
- Terraform >= 1.5

## Quick workflow

1. Bootstrap Terraform and create infra:

```bash
cd lesson-7
terraform init
terraform plan
terraform apply
```

2. Configure kubectl:

```bash
aws eks update-kubeconfig --region eu-north-1 --name $(terraform output -raw cluster_name)
```

3. Deploy the application with Helm:

```bash
helm upgrade --install django-app ./charts/django-app \
  --set image.repository=$(terraform output -raw ecr_repository_url) \
  --set image.tag=v1
```

4. Jenkins pipeline:

- Create a pipeline job in Jenkins pointing to the included Jenkinsfile.
- Provide AWS credentials under the `aws-creds` ID.
- The pipeline builds the image, pushes it to ECR, and updates the Helm values tag.

5. Argo CD:

- Install Argo CD via Terraform module.
- Point the application manifest in the Argo CD chart to the target Git repository containing the Helm chart.

## Files of interest

- main.tf - root Terraform wiring
- backend.tf - S3 backend configuration for remote state
- modules/ecr - creates the ECR repository with AES256 encryption
- modules/eks - creates the EKS cluster and managed node group
- modules/jenkins - installs Jenkins via Helm with Terraform
- modules/argo_cd - installs Argo CD via Helm with Terraform
- charts/django-app - Helm chart with Deployment, Service, ConfigMap, HPA, and probes
- Jenkinsfile - CI pipeline for building, pushing, and updating the chart
- django/ - simple Django application container scaffold

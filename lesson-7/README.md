# Lesson 7 - EKS + ECR + Helm deployment for Django

This folder contains Terraform modules and a Helm chart to deploy the Django application to an EKS cluster in the same VPC created earlier.

Requirements

- AWS CLI configured with credentials
- kubectl and helm installed
- Docker installed for building images

Quick workflow

1. Bootstrap Terraform (local backend) and create infra (ECR + EKS skeleton)

```bash
cd lesson-7
terraform init
terraform plan
terraform apply
```

2. Build and push Django Docker image to ECR:

```bash
# replace <ECR_URL> with terraform output or AWS console value
./scripts/build-and-push.sh <ECR_URL> v1
```

3. Configure kubectl (use Terraform outputs):

```bash
aws eks update-kubeconfig --region eu-north-1 --name $(terraform output -raw eks_cluster_name)
```

4. Deploy the application with Helm (set image values):

```bash
helm install django-app ./charts/django-app --set image.repository=<ECR_URL>,image.tag=v1
```

Files of interest

- `main.tf` - root terraform wiring
- `backend.tf` - local backend for bootstrap
- `modules/ecr` - creates ECR repository
- `modules/eks` - creates EKS cluster and managed node group (requires existing VPC subnets)
- `charts/django-app` - Helm chart (Deployment, Service, ConfigMap, HPA)
- `scripts/build-and-push.sh` - helper to push Docker image to ECR

ConfigMap / env

- `charts/django-app/values.yaml` contains example environment variables under `env` which are rendered into a `ConfigMap` and injected into pods with `envFrom`.

Notes

- The EKS module expects `subnet_ids` from the existing VPC (private subnets recommended for nodes).
- After the resources are created, set `image.repository` to the ECR repo URL and deploy via Helm.

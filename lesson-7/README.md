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

## Як застосувати Terraform

1. Ініціалізація та застосування інфраструктури:
```bash
cd lesson-7
terraform init
terraform plan
terraform apply -auto-approve
```

## Як перевірити Jenkins job

1. Увійдіть у веб-інтерфейс Jenkins, використовуючи дані (URL та пароль), які можна отримати з `terraform output`.
2. Створіть новий Pipeline job (New Item -> Pipeline).
3. В налаштуваннях job:
   - Вкажіть `Pipeline script from SCM` (з Git).
   - Вкажіть ваш Git-репозиторій, де зберігається код з цього завдання (`Jenkinsfile`).
   - Налаштуйте Credentials для доступу до вашого Git (ідентифікатор: `github-credentials` з логіном та паролем/токеном Github).
4. Запустіть збірку (Build Now).
5. Пайплайн використовує Kaniko (в Kubernetes агенті) для збирання Docker образу з папки `django`, публікує його в AWS ECR та автоматично комітить оновлений тег (`charts/django-app/values.yaml`) у ваш Git-репозиторій.

## Як побачити результат в Argo CD

1. Отримайте пароль адміністратора та URL Argo CD з `terraform output`.
2. Відкрийте Argo CD UI і увійдіть як `admin`.
3. Оскільки Argo CD налаштовано через Helm Chart, він автоматично створить Application для `django-app`.
4. Argo CD буде автоматично відслідковувати зміни у вашому Git-репозиторії. Після того як Jenkins оновить тег у `values.yaml` та зробить пуш, Argo CD підхопить зміни (через `syncPolicy.automated`) і оновить Deployment у кластері (EKS).
5. Перевірте, що стан застосунку став `Healthy` та `Synced`.

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

# CI/CD project for Django + EKS + Jenkins + Argo CD

This repository contains a complete CI/CD setup for a Django application deployed to Amazon EKS with Jenkins, Helm, Terraform, and Argo CD.

## 1. How to apply Terraform

1. Go to the lesson-7 directory:

```bash
cd lesson-7
```

2. Initialize Terraform:

```bash
terraform init
```

3. Review the planned infrastructure:

```bash
terraform plan
```

4. Apply the configuration:

```bash
terraform apply
```

5. Get useful outputs:

```bash
terraform output
```

This will create the EKS cluster, ECR repository, Jenkins, and Argo CD resources.

## 2. How to verify the Jenkins job

1. Get the Jenkins URL from the service or from your cluster access point.
2. Open Jenkins in the browser and log in with the admin credentials configured in the Helm values.
3. Create a pipeline job that uses the included Jenkinsfile.
4. Run the job manually and check the build log.

Expected result:

- The Docker image is built.
- The image is pushed to ECR.
- The Helm values file is updated with the new image tag.
- The changes are committed and pushed to the Git branch.

You can also verify the image in ECR:

```bash
aws ecr describe-images --repository-name lesson-5-ecr --region eu-north-1
```

## 3. How to see the result in Argo CD

1. Open the Argo CD UI in your browser.
2. Find the application entry created by the Argo CD Helm chart.
3. Check that the application is in Sync and Healthy state.
4. If the Git repository changes, Argo CD will automatically sync the new Helm chart values.

You can also verify the deployed resources from the cluster:

```bash
kubectl get pods
kubectl get svc
kubectl get applications -n argocd
```

## 4. Typical workflow

1. Jenkins builds and pushes a new image to ECR.
2. Jenkins updates the image tag in the Helm chart values.
3. Argo CD detects the Git change.
4. Argo CD syncs the updated Helm chart into the cluster.

This completes the CI/CD loop from code change to deployment.

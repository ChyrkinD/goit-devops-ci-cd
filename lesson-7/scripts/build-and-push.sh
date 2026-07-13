#!/usr/bin/env bash
set -euo pipefail

# Usage: ./build-and-push.sh <ecr_repo_url> <image_tag>
ECR_REPO_URL=${1:-}
IMAGE_TAG=${2:-"latest"}

if [ -z "$ECR_REPO_URL" ]; then
  echo "Usage: $0 <ecr_repo_url> [image_tag]"
  exit 1
fi

# Build image
docker build -t ${ECR_REPO_URL}:${IMAGE_TAG} ./django

# Authenticate Docker to ECR
aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin ${ECR_REPO_URL%/*}

# Push
docker push ${ECR_REPO_URL}:${IMAGE_TAG}

echo "Pushed ${ECR_REPO_URL}:${IMAGE_TAG}"
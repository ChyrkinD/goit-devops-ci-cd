resource "helm_release" "jenkins" {
  name             = "jenkins"
  namespace        = var.namespace
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  version          = var.chart_version
  create_namespace = true

  values = [
    templatefile("${path.module}/values.yaml.tftpl", {
      jenkins_admin_password = var.jenkins_admin_password
      aws_account_id         = var.aws_account_id
      ecr_repository_url     = var.ecr_repository_url
      git_repo_url           = var.git_repo_url
    })
  ]

  # Attach IRSA annotation to the Jenkins service account so it can push to ECR
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.jenkins_irsa.arn
  }
}

# IAM Role for Jenkins Service Account to push to ECR (IRSA)
resource "aws_iam_role" "jenkins_irsa" {
  name = "jenkins-irsa-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.eks_oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            # Matches standard OIDC subject format for Kubernetes ServiceAccount
            "${replace(var.eks_oidc_provider_arn, "/^(.*provider/)/", "")}:sub" : "system:serviceaccount:${var.namespace}:jenkins"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_ecr_poweruser" {
  role       = aws_iam_role.jenkins_irsa.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

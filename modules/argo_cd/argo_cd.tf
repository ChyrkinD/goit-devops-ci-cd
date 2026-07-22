resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = var.namespace
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.chart_version
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}

resource "local_file" "argocd_apps_values" {
  content = templatefile("${path.module}/charts/values.yaml.tftpl", {
    git_repo_url = var.git_repo_url
  })
  filename = "${path.module}/charts/values.yaml"
}

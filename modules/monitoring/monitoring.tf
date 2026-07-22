# Створення namespace для моніторингу
resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

# Встановлення Helm-чарту kube-prometheus-stack
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace_v1.monitoring.metadata[0].name
  version    = "61.3.0" # Стабільна версія

  # Налаштування Grafana admin password (тут для прикладу базовий, в проді - secrets)
  set {
    name  = "grafana.adminPassword"
    value = var.grafana_admin_password
  }

  # Вимикаємо default rules, які можуть конфліктувати
  set {
    name  = "defaultRules.create"
    value = "false"
  }

  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = "false"
  }
}

# Встановлення metrics-server для роботи HPA
resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = kubernetes_namespace_v1.monitoring.metadata[0].name
  version    = "3.12.1"
}

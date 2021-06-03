resource "helm_release" "vpc_cni" {
  depends_on = [var.mod_dependency, kubernetes_namespace.vpc_cni]
  count      = var.enabled ? 1 : 0
  name       = var.helm_chart_name
  chart      = var.helm_chart_release_name
  repository = var.helm_chart_repo
  version    = var.helm_chart_version
  namespace  = var.namespace

  set {
    name  = "crd.create"
    value = false
  }

  set {
    name  = "originalMatchLabels"
    value = true
  }

  set {
    name  = "serviceAccount.name"
    value = var.service_account_name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.vpc_cni[0].arn
  }

  set {
    name  = "init.image.region"
    value = var.region
  }

  values = [
    yamlencode(var.settings)
  ]
}
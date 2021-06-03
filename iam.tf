data "aws_iam_policy_document" "vpc_cni_assume" {
  count = var.enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_identity_oidc_issuer_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.namespace}:${var.service_account_name}",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "vpc_cni" {
  count = var.enabled ? 1 : 0

  name               = "${var.cluster_name}-vpc-cni"
  assume_role_policy = data.aws_iam_policy_document.vpc_cni_assume[0].json
}

resource "aws_iam_role_policy_attachment" "vpc_cni" {
  count = var.enabled ? 1 : 0

  role       = aws_iam_role.vpc_cni[0].name
  policy_arn = data.aws_iam_policy.vpc_cni[0].arn
}
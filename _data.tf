data "aws_iam_policy" "vpc_cni" {
  count = var.enabled ? 1 : 0

  arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
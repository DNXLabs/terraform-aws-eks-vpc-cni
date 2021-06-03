module "vpc_cni" {
  source  = "DNXLabs/eks-vpc-cni/aws"
  version = "0.1.0"

  cluster_identity_oidc_issuer     = module.eks_cluster.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks_cluster.oidc_provider_arn
  cluster_name                     = module.eks_cluster.cluster_id
  region                           = data.aws_region.current.name

  depends_on = [module.eks]
}
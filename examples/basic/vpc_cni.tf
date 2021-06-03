module "vpc_cni" {
  source  = "DNXLabs/eks-vpc-cni/aws"
  version = "0.1.0"

  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  cluster_name                     = module.eks.cluster_id

  depends_on = [module.eks]
}
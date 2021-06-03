# terraform-aws-eks-vpc-cni

[![Lint Status](https://github.com/DNXLabs/terraform-aws-eks-vpc-cni/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-eks-vpc-cni/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-eks-vpc-cni)](https://github.com/DNXLabs/terraform-aws-eks-vpc-cni/blob/master/LICENSE)

Terraform module for deploying [AWS Load Balancer Controller](https://github.com/kubernetes-sigs/aws-load-balancer-controller) inside a pre-existing EKS cluster.

## Usage

```
module "vpc_cni" {
  source  = "DNXLabs/eks-vpc-cni/aws"
  version = "0.1.0"

  cluster_identity_oidc_issuer     = module.eks_cluster.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks_cluster.oidc_provider_arn
  cluster_name                     = module.eks_cluster.cluster_id
  region                           = data.aws_region.current.name

  depends_on = [module.eks_cluster]
}
```

## Adopting the existing aws-node resources in an EKS cluster

If you do not want to delete the existing aws-node resources in your cluster that run the aws-vpc-cni and then install this helm chart, you can adopt the resources into a release instead. This process is highlighted in this [PR comment](https://github.com/aws/eks-charts/issues/57#issuecomment-628403245). Once you have annotated and labeled all the resources this chart specifies, enable the `originalMatchLabels` flag, and also set `crd.create` to false on the helm release and run an update. If you have been careful this should not diff and leave all the resources unmodified and now under management of helm.

Here is an example script to modify the existing resources:

WARNING: Substitute YOUR_HELM_RELEASE_NAME_HERE with the name of your helm release.

```bash
#!/usr/bin/env bash

set -euo pipefail

# don't import the crd. Helm cant manage the lifecycle of it anyway.
for kind in daemonSet clusterRole clusterRoleBinding serviceAccount; do
  echo "setting annotations and labels on $kind/aws-node"
  kubectl -n kube-system annotate --overwrite $kind aws-node meta.helm.sh/release-name=YOUR_HELM_RELEASE_NAME_HERE
  kubectl -n kube-system annotate --overwrite $kind aws-node meta.helm.sh/release-namespace=kube-system
  kubectl -n kube-system label --overwrite $kind aws-node app.kubernetes.io/managed-by=Helm
done
```

```
module "vpc_cni" {
  source  = "DNXLabs/eks-vpc-cni/aws"
  version = "0.1.0"

  cluster_identity_oidc_issuer     = module.eks_cluster.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks_cluster.oidc_provider_arn
  cluster_name                     = module.eks_cluster.cluster_id
  region                           = data.aws_region.current.name

  crd_create            = false
  original_match_labels = true

  depends_on = [module.eks_cluster]
}
```

<!--- BEGIN_TF_DOCS --->

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.13 |
| aws | >= 3.13, < 4.0 |
| helm | >= 1.0, < 3.0 |
| kubernetes | >= 1.10.0, < 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.13, < 4.0 |
| helm | >= 1.0, < 3.0 |
| kubernetes | >= 1.10.0, < 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_identity\_oidc\_issuer | The OIDC Identity issuer for the cluster. | `string` | n/a | yes |
| cluster\_identity\_oidc\_issuer\_arn | The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account. | `string` | n/a | yes |
| cluster\_name | The name of the cluster. | `string` | n/a | yes |
| crd\_create | Specifies whether to create the VPC-CNI CRD. | `bool` | `true` | no |
| create\_namespace | Whether to create Kubernetes namespace with name defined by `namespace`. | `bool` | `true` | no |
| enabled | Variable indicating whether deployment is enabled. | `bool` | `true` | no |
| helm\_chart\_name | AWS Load Balancer Controller Helm chart name. | `string` | `"aws-vpc-cni"` | no |
| helm\_chart\_release\_name | AWS Load Balancer Controller Helm chart release name. | `string` | `"aws-vpc-cni"` | no |
| helm\_chart\_repo | AWS Load Balancer Controller Helm repository name. | `string` | `"https://aws.github.io/eks-charts"` | no |
| helm\_chart\_version | AWS Load Balancer Controller Helm chart version. | `string` | `"1.1.5"` | no |
| mod\_dependency | Dependence variable binds all AWS resources allocated by this module, dependent modules reference this variable. | `any` | `null` | no |
| namespace | AWS VPC CNI Helm chart namespace which the service will be created. | `string` | `"kube-system"` | no |
| original\_match\_labels | Use the original daemonset matchLabels. | `bool` | `false` | no |
| region | ECR repository region to use. Should match your cluster. | `string` | `"us-west-2"` | no |
| service\_account\_name | The kubernetes service account name. | `string` | `"aws-vpc-cni"` | no |
| settings | Additional settings which will be passed to the Helm chart values, see https://github.com/aws/eks-charts/tree/master/stable/aws-vpc-cni. | `map` | `{}` | no |

## Outputs

No output.

<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-eks-vpc-cni/blob/master/LICENSE) for full details.

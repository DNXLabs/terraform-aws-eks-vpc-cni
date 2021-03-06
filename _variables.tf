variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled."
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster."
}

variable "region" {
  type        = string
  default     = "us-west-2"
  description = "ECR repository region to use. Should match your cluster."
}

variable "cluster_identity_oidc_issuer" {
  type        = string
  description = "The OIDC Identity issuer for the cluster."
}

variable "cluster_identity_oidc_issuer_arn" {
  type        = string
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account."
}

variable "helm_chart_name" {
  type        = string
  default     = "aws-vpc-cni"
  description = "AWS Load Balancer Controller Helm chart name."
}

variable "helm_chart_release_name" {
  type        = string
  default     = "aws-vpc-cni"
  description = "AWS Load Balancer Controller Helm chart release name."
}

variable "helm_chart_repo" {
  type        = string
  default     = "https://aws.github.io/eks-charts"
  description = "AWS Load Balancer Controller Helm repository name."
}

variable "helm_chart_version" {
  type        = string
  default     = "1.1.5"
  description = "AWS Load Balancer Controller Helm chart version."
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create Kubernetes namespace with name defined by `namespace`."
}

variable "crd_create" {
  type        = bool
  default     = true
  description = "Specifies whether to create the VPC-CNI CRD."
}

variable "original_match_labels" {
  type        = bool
  default     = false
  description = "Use the original daemonset matchLabels."
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "AWS VPC CNI Helm chart namespace which the service will be created."
}

variable "service_account_name" {
  default     = "aws-vpc-cni"
  description = "The kubernetes service account name."
}

variable "mod_dependency" {
  default     = null
  description = "Dependence variable binds all AWS resources allocated by this module, dependent modules reference this variable."
}

variable "settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://github.com/aws/eks-charts/tree/master/stable/aws-vpc-cni."
}

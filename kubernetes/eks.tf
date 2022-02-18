data "tfe_outputs" "bootstrap" {
  organization = "recrd"
  workspace    = "bootstrap"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.0.6"

  cluster_name    = "test"
  cluster_version = "1.21"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  cluster_endpoint_public_access_cidrs = [
    "188.214.10.130/32", # mate@home
  ]

  vpc_id     = data.tfe_outputs.bootstrap.values.vpc_id
  subnet_ids = data.tfe_outputs.bootstrap.values.eks_subnet_ids

  eks_managed_node_groups = {
    # TODO: Cluster Autoscaler
    # TODO: One node group per AZ?
    default_node_group = {
      # By default, the module creates a launch template to ensure tags are propagated to instances, etc.,
      # so we need to disable it to use the default template provided by the AWS EKS managed node group service
      create_launch_template = false
      launch_template_name   = ""

      subnet_ids = data.tfe_outputs.bootstrap.values.private_subnet_ids
    }
  }

  enable_irsa = true # NOTE: IAM roles for service accounts

  cluster_encryption_config = toset([{
    provider_key_arn = nonsensitive(data.tfe_outputs.bootstrap.values.eks_secret_encryption_key_arn)
    resources        = ["secrets"]
  }])
}

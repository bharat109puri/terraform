data "tfe_outputs" "bootstrap" {
  organization = "recrd"
  workspace    = "bootstrap"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.0.6"

  cluster_name    = data.tfe_outputs.bootstrap.values.eks_cluster_name
  cluster_version = var.eks_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false

  cluster_security_group_additional_rules = {
    vpn_access_443 = {
      description              = "Allow VPN clients to access cluster API"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      type                     = "ingress"
      source_security_group_id = data.tfe_outputs.bootstrap.values.vpn_clients_security_group_id
    }
  }

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

      ami_type = "AL2_x86_64"

      instance_types = ["t3.medium"]
      disk_size      = 20

      min_size     = 1
      max_size     = 8
      desired_size = 3

      subnet_ids = data.tfe_outputs.bootstrap.values.private_subnet_ids
    }
  }

  enable_irsa = true # NOTE: irsa: IAM roles for service accounts

  cluster_encryption_config = toset([{
    provider_key_arn = nonsensitive(data.tfe_outputs.bootstrap.values.eks_secret_encryption_key_arn)
    resources        = ["secrets"]
  }])
}

module "cluster_autoscaler" {
  source = "git::https://github.com/DNXLabs/terraform-aws-eks-cluster-autoscaler.git"

  enabled = true

  cluster_name                     = module.eks.cluster_id
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  aws_region                       = var.region
}

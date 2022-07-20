data "tfe_outputs" "bootstrap" {
  organization = "recrd"
  workspace    = "staging_bootstrap"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.0.6"

  cluster_name    = data.tfe_outputs.bootstrap.values.eks_cluster_name #NOTE:local.eks_cluster_name
  cluster_version = var.eks_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false
  /*
  cluster_security_group_additional_rules = {
    vpn_access_443 = {
      description              = "Allow VPN clients to access cluster API"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      type                     = "ingress"
      source_security_group_id = data.tfe_outputs.bootstrap.values.eks_security_group_id #NOTE:aws_security_group.vpn_clients.id
    }
  }
*/
  vpc_id     = data.tfe_outputs.bootstrap.values.vpc_id
  subnet_ids = data.tfe_outputs.bootstrap.values.eks_subnet_ids #NOTE:module.vpc.intra_subnets

  eks_managed_node_groups = {


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
      max_size     = 6
      desired_size = 2

      subnet_ids = data.tfe_outputs.bootstrap.values.private_subnet_ids #!!module.vpc.private_subnets
    }
  }

  enable_irsa = true # NOTE: irsa: IAM roles for service accounts

  cluster_encryption_config = toset([{
    provider_key_arn = nonsensitive(data.tfe_outputs.bootstrap.values.eks_secret_encryption_key_arn) #NOTE: #!!aws_kms_key.eks.arn
    resources        = ["secrets"]
  }])
}

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
}

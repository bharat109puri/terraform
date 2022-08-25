################################################################################
# VPC Module
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = "${var.name}-vpc"
  cidr = var.vpc_cidr

  azs             = local.availability_zones
  private_subnets = local.private_cidrs
  public_subnets  = local.public_cidrs

  enable_ipv6 = true

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Owner       = "recrd"
    Environment = "management"
    CreatedBy   = "terraform"
  }
}

################################################################################
# VPC Peering - Management-Staging
################################################################################

module "management-staging" {
  # source = "git@github.com:RecrdGroup/terraform.git//modules/vpc-peering?ref=UT-82-peering"
  source = "../../../modules/vpc-peering/"

  owner_vpc_id    = module.vpc.vpc_id
  owner_env       = "management"
  owner_region    = var.region
  accepter_vpc_id = data.tfe_outputs.staging_network.values.vpc_id
  accepter_region = var.region
  accepter_env    = "staging"
}

################################################################################
# VPC Peering - Management-Production
################################################################################


module "management-prod" {
  # source = "git@github.com:RecrdGroup/terraform.git//modules/vpc-peering?ref=UT-82-peering"
  source = "../../../modules/vpc-peering/"

  owner_vpc_id    = module.vpc.vpc_id
  owner_env       = "management"
  owner_region    = var.region
  accepter_vpc_id = data.tfe_outputs.prod_network.values.vpc_id
  accepter_region = var.region
  accepter_env    = "prod"
}
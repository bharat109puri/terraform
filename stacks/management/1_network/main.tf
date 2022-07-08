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
  # push the code to master and change the reference"
   source = "../../modules/vpc-peering"

   owner_vpc_id       = module.vpc.vpc_id
   owner_profile      = "default"
   owner_region       = var.region
   accepter_vpc_id    = var.staging_vpc_id
   accepter_region    = var.region
   accepter_profile   = "default"
   
 }
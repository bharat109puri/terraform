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
    Environment = "staging"
    CreatedBy   = "terraform"
  }
}

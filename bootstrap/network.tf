locals {
  # NOTE: Needs to match EKS cluster name to able to provision load balancers
  eks_cluster_name = "test"

  vpc_cidr   = "10.0.0.0/16"
  _all_cirds = cidrsubnets(local.vpc_cidr, 2, 2, 2, 4, 4, 4, 12, 12, 12, 6) # NOTE: /16 -> /18, /18, /18, /20, /20, /20, /28, /28, /28, /22

  private_cidrs = slice(local._all_cirds, 0, 3)
  public_cidrs  = slice(local._all_cirds, 3, 6)
  eks_cidrs     = slice(local._all_cirds, 6, 9)
  vpn_cidr      = local._all_cirds[9]

  dns_ip = cidrhost(local.vpc_cidr, 2)

  availability_zones = slice(sort(data.aws_availability_zones.available.names), 0, 3) # NOTE: Requires 3 availability zones
}

data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3"

  name = "test"
  cidr = local.vpc_cidr

  azs             = local.availability_zones
  private_subnets = local.private_cidrs
  public_subnets  = local.public_cidrs
  intra_subnets   = local.eks_cidrs

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                          = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                 = 1
  }

  enable_nat_gateway     = true
  one_nat_gateway_per_az = true

  # TODO
  #enable_flow_log                      = true
  #create_flow_log_cloudwatch_iam_role  = true
  #create_flow_log_cloudwatch_log_group = true

  # EKS requirements
  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true
}

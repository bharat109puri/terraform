module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.12.0"

  name = "${var.name}-vpc"
  cidr = var.vpc_cidr

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

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  # EKS requirements
  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true
}

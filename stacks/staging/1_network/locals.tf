locals {
  # NOTE: Subnets must be tagged with EKS cluster name to able to provision load balancers
  eks_cluster_name = "${var.name}-kubernetes"

  _all_cirds = cidrsubnets(var.vpc_cidr, 2, 2, 4, 4, 8, 8, 6) # NOTE: /16 -> /22, /22, /24, /24, /28, /28, /26

  private_cidrs = slice(local._all_cirds, 0, 2)
  public_cidrs  = slice(local._all_cirds, 2, 4)
  eks_cidrs     = slice(local._all_cirds, 4, 6)

  dns_ip = cidrhost(var.vpc_cidr, 2)

  availability_zones = slice(sort(data.aws_availability_zones.available.names), 0, 3) # NOTE: Will fail if region has less than 3 availability zones
}

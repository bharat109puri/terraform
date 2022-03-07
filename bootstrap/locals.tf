locals {
  # NOTE: Subnets must be tagged with EKS cluster name to able to provision load balancers
  eks_cluster_name = "${var.name}-kubernetes"

  _all_cirds = cidrsubnets(var.vpc_cidr, 2, 2, 2, 4, 4, 4, 12, 12, 12, 6) # NOTE: /16 -> /18, /18, /18, /20, /20, /20, /28, /28, /28, /22

  private_cidrs = slice(local._all_cirds, 0, 3)
  public_cidrs  = slice(local._all_cirds, 3, 6)
  eks_cidrs     = slice(local._all_cirds, 6, 9)
  vpn_cidr      = local._all_cirds[9]

  dns_ip = cidrhost(var.vpc_cidr, 2)

  availability_zones = slice(sort(data.aws_availability_zones.available.names), 0, 3) # NOTE: Will fail if region has less than 3 availability zones

  # CloudTrail
  cloudtrail_bucket_name = "recrd-cloudtrail"
  s3_key_prefix          = "management"
  trail_name             = "management-trail"
}

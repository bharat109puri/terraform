locals {
  eks_addon_ecr = "602401143452.dkr.ecr.eu-west-1.amazonaws.com" # NOTE: https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  domain        = "ad-recrd.com"                                 # TODO: Use real domain

  aws_load_balancer_controller_name = "aws-load-balancer-controller"
  external_dns_controller_name      = "external-dns-controller"
}

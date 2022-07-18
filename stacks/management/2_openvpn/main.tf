# Openvpn
module "openvpn" {
  source                       = "../../../modules/openvpn/"
  openvpn_tags                 = var.tags
  openvpn_asg_tags             = var.openvpn_asg_tags
  openvpn_ami_id               = var.openvpn_ami_id
  name_prefix                  = var.name
  openvpn_instance_type        = var.openvpn_instance_type
  openvpn_key_name             = var.openvpn_key_name
  openvpn_root_volume_type     = var.openvpn_root_volume_type
  openvpn_root_volume_size     = var.openvpn_root_volume_size
  openvpn_max_size             = var.openvpn_max_size
  openvpn_min_size             = var.openvpn_min_size
  openvpn_desired_capacity     = var.openvpn_desired_capacity
  openvpn_instance_subnets_ids = data.tfe_outputs.public_subnets
  aws_region                   = var.aws_region
  vpc_id                       = data.tfe_outputs.vpc_id
  vpc_cidr                     = data.tfe_outputs.vpc_cidr_block
  OpenVpnAdminUser             = var.OpenVpnAdminUser
  OpenVpnAdminPassword         = var.OpenVpnAdminPassword
  openvpnBackupBucket          = var.openvpnBackupBucket
}
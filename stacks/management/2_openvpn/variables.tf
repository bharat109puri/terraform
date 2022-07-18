#===============================================================================
# General
#===============================================================================

variable "name" {
  description = "Used to prefix resources created by this template."
}

variable "tags" {
  description = "Tags you want on resources created by this template."
  type        = map(string)
}

variable "aws_region" {
  description = "aws region name"
}

variable "tfe_token" {
  description = "Terraform Cloud Team token"
  type        = string
  sensitive   = true
}
#===============================================================================
# openvpn
#===============================================================================
variable "openvpn_asg_tags" {
  type = list(string)
}

variable "openvpn_ami_id" {}
variable "openvpn_instance_type" {}
variable "openvpn_key_name" {}
variable "openvpn_root_volume_type" {}
variable "openvpn_root_volume_size" {}
variable "openvpn_max_size" {}
variable "openvpn_min_size" {}
variable "openvpn_desired_capacity" {}

variable "OpenVpnAdminUser" {
  default     = "openvpn"
  description = "default admin username of openvpn"
}

variable "OpenVpnAdminPassword" {
  default     = "openvpn"
  description = "default admin password of openvpn"
}

variable "openvpnBackupBucket" {}




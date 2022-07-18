variable "openvpnBackupBucket" {
  description = "The name of the S3 bucket where OpenVPN backups will be stored."
}

variable "name_prefix" {
  description = "Name prefix to tag different AWS resources"
  default     = "OpenVPN"
}

variable "openvpn_tags" {
  description = "A map of tags to add to openvpn Related AWS resources"
  type        = map(string)
}

variable "openvpn_asg_tags" {
  description = "A List of tags to add to ASG EC2 instances."
  type        = map(string)
}

variable "openvpn_instance_subnets_ids" {
  description = "A list of  subnet IDs to launch ASG resources in."
  type        = list(string)
}

variable "openvpn_instance_type" {
  description = "The size of EC2 instance to launch."
  default     = "t2.medium"
}

variable "openvpn_key_name" {
  description = "The ssh key name that is in AWS."
  default     = "openvpn"
}

variable "openvpn_root_volume_type" {
  description = "The type of volume. Can be standard, gp2, or io1. (Default: standard)"
  default     = "standard"
}

variable "openvpn_root_volume_size" {
  description = "The size of the volume in gigabytes."
  default     = "20"
}

variable "openvpn_max_size" {
  description = "The maximum size of the auto scale group."
  default     = 1
}

variable "openvpn_min_size" {
  description = "The minimum size of the auto scale group."
  default     = 1
}

variable "openvpn_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group."
  default     = 1
}

variable "openvpn_user_data" {
  description = "The user data to provide when launching openvpn instance"
  default     = ""
}

variable "ami_openvpn_regex" {
  default     = "OpenVPN Access Server 2.5.0*"
  description = "openvpn from marketplace"
}

variable "openvpn_ami_id" {
  default     = ""
  description = "openvpn AMI ID. Its optional, if not specified it will pick latest ami using ami_openvpn_regex"
}

variable "OpenVpnAdminUser" {
  default     = "openvpn"
  description = "default admin username of openvpn"
}

variable "OpenVpnAdminPassword" {
  default     = "openvpn"
  description = "default admin password of openvpn"
}

variable "aws_region" {
  default     = "us-east-1"
  description = "default admin username of openvpn"
}

variable "vpc_id" {}

variable "vpc_cidr" {}

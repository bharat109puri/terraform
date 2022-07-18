#===============================================================================
# General
#===============================================================================
name = "recrd"
tags = {
  Environment = "management"
  Version     = "v1.0"
  Terraform   = "true"
}
aws_region = "eu-west-1"

#===============================================================================
# openvpn
#===============================================================================
openvpn_instance_type    = "t2.micro"
openvpn_key_name         = "chijioke-key"
openvpn_ami_id           = "ami-0e1415fedc1664f51" ## free 2 user license
openvpn_root_volume_type = "standard"
openvpn_root_volume_size = "20"
openvpn_max_size         = 1
openvpn_min_size         = 1
openvpn_desired_capacity = 1
OpenVpnAdminUser         = "openvpn"
OpenVpnAdminPassword     = "TY>c}pinTw27J*Jy"
openvpn_vpc_cidr         = "10.0.0.0/16"
openvpnBackupBucket      = "recrd-management-eu-west-1"
openvpn_asg_tags = [
  {
    key                 = "Service"
    value               = "openvpn"
    propagate_at_launch = true
  }
]

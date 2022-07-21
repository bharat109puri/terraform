#===============================================================================
# General
#===============================================================================
name = "management-recrd"
tags = {
  Environment = "management"
  Version     = "v1.0"
  Terraform   = "true"
}
region = "eu-west-1"

#===============================================================================
# openvpn
#===============================================================================
openvpn_instance_type    = "m3.medium"
openvpn_key_name         = "chijioke-key"
openvpn_ami_id           = "ami-0d432afa53d094073" ##  25 user license
openvpn_root_volume_type = "standard"
openvpn_root_volume_size = "20"
openvpn_max_size         = 1
openvpn_min_size         = 1
openvpn_desired_capacity = 1
OpenVpnAdminUser         = "openvpn"
OpenVpnAdminPassword     = "TY>c}pinTw27J*Jy"
openvpnBackupBucket      = "recrd-management-eu-west-1"
openvpn_asg_tags = {
  key                 = "Service"
  value               = "openvpn"
  propagate_at_launch = true
  Terraform           = "true"
}
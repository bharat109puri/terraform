data "aws_caller_identity" "current" {}

data "template_file" "openvpn_userdata" {
  template = file("${path.module}/scripts/openvpn_userdata.sh")
  vars {
    OpenvpnBackupBucket     = var.openvpnBackupBucket
    Aws_Region              = var.aws_region
    OpenVpnAdminUser        = var.OpenVpnAdminUser
    OpenVpnAdminPassword    = var.OpenVpnAdminPassword
    OpenVpnEIP              = aws_eip.openvpn_eip.public_ip
    OpenVpnEIP_AllocationId = aws_eip.openvpn_eip.id
    Vpc_Cidr                = var.vpc_cidr
  }
}

## Setup script to be called by the cloud-config
data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "openvpn_userdata.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.openvpn_userdata.rendered
  }

}

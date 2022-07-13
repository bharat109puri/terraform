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


## IAM policies
data "aws_iam_policy_document" "openvpn_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "openvpn_role_policy" {
  statement {
    actions   = ["*"]
    resources = ["*"]
  }

  statement {
    actions   = ["aws-portal:*Billing"]
    resources = ["*"]
    effect    = "Deny"
  }

  statement {
    actions = [
      "cloudtrail:DeleteTrail",
      "cloudtrail:StopLogging",
      "cloudtrail:UpdateTrail",
    ]

    resources = ["*"]
    effect    = "Deny"
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.openvpnBackupBucket}"]
  }

  statement {
    actions = [
      "s3:Put*",
      "s3:Get*",
      "s3:List*",
    ]

    resources = [
      "arn:aws:s3:::${var.openvpnBackupBucket}/backups/openvpn",
      "arn:aws:s3:::${var.openvpnBackupBucket}/backups/openvpn/*"
    ]
  }
}

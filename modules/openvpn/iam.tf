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

# # openvpn EC2 Role
resource "aws_iam_role" "openvpn_instance_role" {
  name               = "${var.name_prefix}-openvpn-instance-role"
  path               = "/"
  description        = "Openvpn EC2 Role"
  assume_role_policy = data.aws_iam_policy_document.openvpn_assume_role_policy.json
}

# openvpn Master EC2 Policy
resource "aws_iam_policy" "openvpn_policy" {
  name        = "${var.name_prefix}-openvpn-policy"
  path        = "/"
  description = "Openvpn EC2 Policy"
  policy      = data.aws_iam_policy_document.openvpn_role_policy.json
}

# openvpn EC2 Policy Attachement
resource "aws_iam_role_policy_attachment" "openvpn_policy_attachment" {
  role       = aws_iam_role.openvpn_instance_role.name
  policy_arn = aws_iam_policy.openvpn_policy.arn
}

# openvpn EC2 Instance Profile
resource "aws_iam_instance_profile" "openvpn_instance_profile" {
  name = "${var.name_prefix}-openvpn-instance-profile"
  role = aws_iam_role.openvpn_instance_role.name
  path = "/"
}

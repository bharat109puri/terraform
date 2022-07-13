resource "aws_eip" "openvpn_eip" {
  vpc = true
  tags = {
    Name = "${var.name_prefix}-openvpn-eip"
  }
}
resource "aws_autoscaling_group" "openvpn_asg" {
  depends_on                = [aws_eip.openvpn_eip]
  name                      = aws_launch_configuration.openvpn_lc.name
  vpc_zone_identifier       = var.openvpn_instance_subnets_ids
  launch_configuration      = aws_launch_configuration.openvpn_lc.name
  health_check_type         = "EC2"
  max_size                  = var.openvpn_min_size
  min_size                  = var.openvpn_max_size
  desired_capacity          = var.openvpn_desired_capacity
  wait_for_capacity_timeout = 0
  tags                      = ["${merge({ "Name" = "${var.name_prefix}-openvpn" }, var.openvpn_asg_tags)}"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "openvpn_lc" {
  name_prefix          = "${var.name_prefix}-OpenVpn-lc-"
  image_id             = var.openvpn_ami_id
  instance_type        = var.openvpn_instance_type
  iam_instance_profile = aws_iam_instance_profile.openvpn_instance_profile.name
  key_name             = var.openvpn_key_name
  security_groups      = [aws_security_group.openvpn_asg_sg.id]
  user_data            = data.template_cloudinit_config.config.rendered
  root_block_device {
    volume_size = var.openvpn_root_volume_size
    volume_type = var.openvpn_root_volume_type
  }

  lifecycle {
    create_before_destroy = true
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

resource "aws_security_group" "openvpn_asg_sg" {
  name        = "${var.name_prefix}-OpenVpn-asg-sg"
  description = "Security group for OpenVpn ASG"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 943
    to_port     = 943
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
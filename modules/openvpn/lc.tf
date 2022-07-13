resource "aws_launch_configuration" "openvpn_lc" {
  name_prefix   = "${var.name_prefix}-OpenVpn-lc-"
  image_id      = var.openvpn_ami_id
  instance_type = var.openvpn_instance_type
  # iam_instance_profile = "${aws_iam_instance_profile.openvpn_instance_profile.name}"
  key_name        = var.openvpn_key_name
  security_groups = ["${aws_security_group.openvpn_asg_sg.id}"]
  user_data       = data.template_cloudinit_config.config.rendered
  root_block_device {
    volume_size = var.openvpn_root_volume_size
    volume_type = var.openvpn_root_volume_type
  }

  lifecycle {
    create_before_destroy = true
  }
}

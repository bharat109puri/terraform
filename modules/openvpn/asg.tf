resource "aws_eip" "openvpn_eip" {
  vpc = true
  tags {
    Name = "${var.name_prefix}-openvpn-eip"
  }
}
resource "aws_autoscaling_group" "openvpn_asg" {
  depends_on                = ["aws_eip.openvpn_eip"]
  name                      = aws_launch_configuration.openvpn_lc.name
  vpc_zone_identifier       = ["${var.openvpn_instance_subnets_ids}"]
  launch_configuration      = aws_launch_configuration.openvpn_lc.name
  health_check_type         = "EC2"
  max_size                  = var.openvpn_min_size
  min_size                  = var.openvpn_max_size
  desired_capacity          = var.openvpn_desired_capacity
  wait_for_capacity_timeout = 0
  tags                      = ["${concat(list(map("key", "Name", "value", format("%s-openvpn", var.name_prefix), "propagate_at_launch", true)), var.openvpn_asg_tags)}"]

  lifecycle {
    create_before_destroy = true
  }
}

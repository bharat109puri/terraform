output "openvpn_eip" {
  value = aws_eip.openvpn_eip.public_ip
}

# output "openvpn_instance_arn" {
#   value = "${aws_iam_instance_profile.openvpn_instance_profile.arn}"
# }

# output "openvpn_instance_role" {
#   value = "${aws_iam_role.openvpn_instance_role.arn}"
# }

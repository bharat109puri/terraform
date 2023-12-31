# resource "aws_iam_saml_provider" "aws_sso_saml_provider" {
#   name                   = "aws_sso_saml_provider"
#   saml_metadata_document = file("client_vpn_saml_app_metadata.xml")
# }

# resource "aws_security_group" "vpn_clients" {
#   name        = "vpn-clients"
#   description = "VPN clients"
#   vpc_id      = module.vpc.vpc_id

#   tags = {
#     Name = "vpn-clients"
#   }
# }

# module "client_vpn" {
#   source  = "cloudposse/ec2-client-vpn/aws"
#   version = "0.10.10"

#   vpc_id              = module.vpc.vpc_id
#   client_cidr         = local.vpn_cidr
#   organization_name   = "recrd"
#   logging_enabled     = false # FIXME: Logging seems to be broken upstream
#   logging_stream_name = "client-vpn"
#   associated_subnets  = module.vpc.private_subnets
#   dns_servers         = [local.dns_ip]
#   split_tunnel        = false

#   associated_security_group_ids = [aws_security_group.vpn_clients.id]

#   ca_common_name     = "recrd.vpn.ca"
#   root_common_name   = "recrd.vpn.client"
#   server_common_name = "recrd.vpn.server"

#   authentication_type = "federated-authentication"
#   saml_provider_arn   = aws_iam_saml_provider.aws_sso_saml_provider.arn

#   authorization_rules = [{
#     authorize_all_groups = true
#     description          = "all"
#     target_network_cidr  = "0.0.0.0/0" # FIXME: All, full VPC, private subnets, VPC endpoints?
#   }]

#   additional_routes = [
#     # NOTE: Routes for non-split VPN
#     for subnet_id in module.vpc.private_subnets :
#     {
#       destination_cidr_block = "0.0.0.0/0"
#       description            = "Default Route (via NAT Gateways)"
#       target_vpc_subnet_id   = subnet_id
#     }
#   ]

#   tags = {
#     Name = "client-vpn"
#   }
# }

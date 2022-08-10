# Kubernetes config

Running `terraform plan` in workspaces where the Kubernetes provider is configured requires [VPN connection][vpn] as the EKS cluster is private.

[vpn]: ../../bootstrap/client_vpn.md

## Helm charts and IAM roles

Helm charts are capable of generating their own `ServiceAccount`s, but this functionality is disabled under this directory.

The reason behind it is to be able to create the Helm release and its IAM role in the same Terraform state.
The `ServiceAccount` requires the `eks.amazonaws.com/role-arn` annotation to point at the ARN of the IAM role,
while the Helm release resource requires all annotations to be available at planning time.

This pattern allows simple management of Helm charts with Terraform.

Order of execution for configs
#######################################################################################################
directory                               |   terraform workspace
#######################################################################################################
1. configs                              | staging_kubernetes__config    - deployed
2. sealed_secrets                       | stage_kubernetes__config__sealed_secrets - deployed
3. aws_load_balancer_controller         | staging_kubernetes__config__aws_load_balancer_controller - deployed
4. external_dns                         | staging_kubernetes__config__external_dns - deployed
5. cert_manager                         | staging_kubernetes__config__cert_manager - deployed
6. cluster_autoscaler                   | staging_kubernetes__config__cluster_autoscaler - deployed
7. actions_runner_controller
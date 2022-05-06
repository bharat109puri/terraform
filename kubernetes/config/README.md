# Kubernetes config

Running `terraform plan` in workspaces where the Kubernetes provider is configured requires [VPN connection][vpn] as the EKS cluster is private.

[vpn]: ../../bootstrap/client_vpn.md

## Helm charts and IAM roles

Helm charts are capable of generating their own `ServiceAccount`s, but this functionality is disabled under this directory.

The reason behind it is to be able to create the Helm release and its IAM role in the same Terraform state.
The `ServiceAccount` requires the `eks.amazonaws.com/role-arn` annotation to point at the ARN of the IAM role,
while the Helm release resource requires all annotations to be available at planning time.

This pattern allows simple management of Helm charts with Terraform.

## Known issues

Due to CRDs these resources must be migrated into separate workspaces.

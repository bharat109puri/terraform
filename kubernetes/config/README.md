# Kubernetes config

## Helm charts and IAM roles

Helm charts are capable of generating their own `ServiceAccount`s, but this functionality is disabled in this directory.

The reason behind it is to be able to create the Helm release and it's IAM role in the same Terraform state.
The `ServiceAccount` requires the `eks.amazonaws.com/role-arn` annotation to point at the ARN of the IAM role,
while the Helm release resource requires all annotations to be available at planning time.

This pattern allows simple management of Helm charts with Terraform.

## aws-load-balancer-controller

https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html

- https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.3.1/docs/install/iam_policy.json

## ExternalDNS

https://github.com/kubernetes-sigs/external-dns/blob/v0.10.2/README.md

- https://github.com/kubernetes-sigs/external-dns/blob/v0.10.2/docs/tutorials/aws.md#iam-policy

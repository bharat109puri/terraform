<!--
To update docs, run:
  docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.16.0 /terraform-docs
-->
# IAM role assumable by Kubernetes ServiceAccounts

To be able to use this module the Kubernetes cluster must have `irsa` enabled.

```terraform
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.0.6"

  ...

  enable_irsa = true # NOTE: irsa: IAM roles for service accounts
}
```

## Helm release

To use this module in tandem with the `helm_release` resource you need to disable `ServiceAccount` creation in the Helm chart and pass in the name of the generated role.

To make this dependency explicit for the `helm_release` specify the `depends_on` argument.

```terraform
resource "helm_release" "external_dns_controller" {
  ...

  depends_on = [
    module.external_dns_controller_role,
  ]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.70 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.7 |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_inline_policy"></a> [inline\_policy](#input\_inline\_policy) | Inline policy for the role | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Kubernetes `ServiceAccount` name | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace for the `ServiceAccount` (must exist) | `string` | n/a | yes |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | OIDC provider ARN exposed by Kubernetes | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

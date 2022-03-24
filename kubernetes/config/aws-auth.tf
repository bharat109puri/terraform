data "tfe_outputs" "users" {
  organization = "recrd"
  workspace    = "users"
}

locals {
  maproles = concat(
    nonsensitive(data.tfe_outputs.kubernetes.values.default_aws_auth_map_roles),
    [
      {
        groups   = [kubernetes_cluster_role_binding_v1.view_binding.subject[0].name]
        rolearn  = nonsensitive(data.tfe_outputs.users.values.RecrdDeveloper_role_arn)
        username = "developer"
      }
    ],
  )
}

resource "kubernetes_cluster_role_binding_v1" "view_binding" {
  metadata {
    name = "view-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "view-group"
  }
}

resource "kubernetes_config_map_v1" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode(local.maproles)
  }
}
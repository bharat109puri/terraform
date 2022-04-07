data "tfe_outputs" "users" {
  organization = "recrd"
  workspace    = "users"
}

locals {
  maproles = concat(
    nonsensitive(data.tfe_outputs.kubernetes.values.default_aws_auth_map_roles),
    [
      {
        groups = sort([
          kubernetes_cluster_role_binding_v1.view.subject[0].name,
          kubernetes_role_binding_v1.default_deploy.subject[0].name,
        ])
        rolearn  = nonsensitive(data.tfe_outputs.users.values.developer_role_arn)
        username = "developer"
      }
    ],
  )
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

# Cluster-wide, restricted, read-only access (built-in `view` ClusterRole)
resource "kubernetes_cluster_role_binding_v1" "view" {
  metadata {
    name = "view"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "view"
  }
}

# Deploy to `default` namespace
resource "kubernetes_role_v1" "deploy" {
  metadata {
    name      = "deploy"
    namespace = "default"
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["patch"]
  }

  rule {
    api_groups = ["bitnami.com"]
    resources  = ["sealedsecrets"]
    verbs      = ["get", "list", "patch", "watch"]
  }
}

resource "kubernetes_role_binding_v1" "default_deploy" {
  metadata {
    name      = "deploy"
    namespace = "default"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "deploy"
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "default-deploy"
  }
}

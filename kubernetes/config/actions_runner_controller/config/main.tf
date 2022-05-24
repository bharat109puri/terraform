data "tfe_outputs" "kubernetes_config" {
  organization = "recrd"
  workspace    = "kubernetes__config"
}

resource "kubernetes_service_account_v1" "github_actions_deployer" {
  metadata {
    name      = "github-actions-deployer"
    namespace = "default"

    labels = {
      "app.kubernetes.io/name" = "github-actions-deployer"
    }
  }
}

resource "kubernetes_cluster_role_binding_v1" "github_actions_deployer_view" {
  metadata {
    name = "github-actions-deployer-view"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.github_actions_deployer.metadata[0].name
    namespace = kubernetes_service_account_v1.github_actions_deployer.metadata[0].namespace
  }
}

resource "kubernetes_cluster_role_binding_v1" "github_actions_deployer_patch" {
  metadata {
    name = "github-actions-deployer-patch"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "patch"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.github_actions_deployer.metadata[0].name
    namespace = kubernetes_service_account_v1.github_actions_deployer.metadata[0].namespace
  }
}

resource "kubernetes_role_binding_v1" "github_actions_deployer_deploy" {
  metadata {
    name      = "github-actions-deployer-deploy"
    namespace = kubernetes_service_account_v1.github_actions_deployer.metadata[0].namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = nonsensitive(data.tfe_outputs.kubernetes_config.values.deploy_role_name)
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.github_actions_deployer.metadata[0].name
    namespace = kubernetes_service_account_v1.github_actions_deployer.metadata[0].namespace
  }
}

resource "kubernetes_manifest" "runner_deployment" {
  manifest = {
    "apiVersion" = "actions.summerwind.dev/v1alpha1"
    "kind"       = "RunnerDeployment"
    "metadata" = {
      "name"      = "k8s-deployer"
      "namespace" = "default"
    }
    "spec" = {
      "replicas" = 1
      "template" = {
        "spec" = {
          "labels"             = ["k8s-deployer"]
          "organization"       = "RecrdGroup"
          "serviceAccountName" = kubernetes_service_account_v1.github_actions_deployer.metadata[0].name
          "securityContext" = {
            "fsGroup" = 65534
          }
          "volumeMounts" = [
            {
              "name"      = "ssh"
              "mountPath" = "/home/runner/.ssh"
              "readOnly"  = true
            }
          ]
          "volumes" = [
            {
              "name" = "ssh"
              "secret" = {
                "secretName"  = "k8s-deployer-ssh"
                "defaultMode" = "0400"
              }
            }
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "ssh_sealed_secret" {
  manifest = {
    "apiVersion" = "bitnami.com/v1alpha1"
    "kind"       = "SealedSecret"
    "metadata" = {
      "name"      = "k8s-deployer-ssh"
      "namespace" = kubernetes_manifest.runner_deployment.manifest.metadata["namespace"]
    }
    "spec" = {
      "encryptedData" = {
        "id_rsa"      = "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"
        "known_hosts" = "AgCS8ASv2VCajZzqj0kawd9H4PtCfBKIQqOysFIlbcA654gp2NSvUCqjatZEn23bj59UPSOAw3B0lVzhouSPvDSZIDsAAAzwCXljLLedeFCFTJwuWOE+8Zdf1kTILt1VCV9xe0DDRikXtgMmIbfhhxY9S1hkJqDowgx4dL0AuCpCOoNDmtsupXR78ywlnjYfuWrLBZzMAMyYaigDDPXB4XMPKLisbPOBQdqapYHhw/A/sp2EGgaWP27v9S9i3fiP1x4VsHl5apPBCTcLY1Xv61gJ5FZS++6/oYZJR0tvX341nLQkVw+t/gnsYKbYCJUBGJka/W9sq6ejD2ryx0iacNw10wi3s9jNdXqLmWCN6Rim/tkduhxsMyb18X/QnrvGUup0e3DzUbbOg/dFZtxRovtvF7lJ0nEdLAJNV8QCxmPi+J2Uu4Ux9D4wLf9t7nLxatc5Fy4IUbQ1ZhF2R6tJLpZXSBl4SXQ9wALVDY7WwVjChOiL8KKIDpwwsIV+mBk3UVkjwsLOurmr81j2iTRhZQkU9wDjTuXIbuS1lLpvzWzB+pBOzGrpwE+jW/dsVj3KpXDCpY5RiVEdWREVeuYAtvKIrhCn0gWEU/MRJePYsWJU87O8uscoetIYvAar+cko46x97xvK03RmDzRAMa464ST2jS5HXBHC507DXK3NitXwpOm68n4DQik24tgoomONnT/7Q/tThq0EmWwPJ/tmzDMumUE12ZjXWXp8clVxFTwZbzrBeQcC5POdDlVTt5PHdn1tRXnw9HinW23Yu757MLkk9vOEZFyPhFpAPhSAiDjxiEsr5XGk/NEPn8aDgRZxKDMRqgoub8cRlNvMGhxRgWNoMi190sniC3a0PkjgtK77uKktLXxG3zIhffyF8Si9/Ty55QAMKMRyOaAxYeB5jzhomMAz9Q4Ev/sZiGG1hhmOZUY5aXTLM591Fdr+/vsF4xJ/jkNzpDLlmNzvpCzLYhMZmiV+Q8T1UlWcHo+QVyPFSjNrFUbbBeH4DeRf2jKPVErHHWiWZ0/Jj05xt1G8YjfZrLEhW3j9SIaxhqtHJRY1bgIyNMZRhJdURN3qEP+1WoU6rqtlwTKf1mQJ6R2kymbD/qVa3AgaAY/fMy7d1R95oGn9UySjqrJi9BEjiyIB4ERY/fnyINGZgYq+/4PUAEbGgPVMbBW5HJIvdDcCw4BjukB+tw1feoJlX2IJYbJnfbehzXm2G3jAHg=="
      }
    }
  }
}

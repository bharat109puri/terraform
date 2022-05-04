resource "kubernetes_namespace_v1" "actions_runner_system" {
  metadata {
    name = "actions-runner-system"
  }
}

# FIXME: Depends on CRDs
resource "kubernetes_manifest" "controller_manager_sealed_secret" {
  manifest = {
    "apiVersion" = "bitnami.com/v1alpha1"
    "kind"       = "SealedSecret"
    "metadata" = {
      "name"      = "controller-manager"
      "namespace" = kubernetes_namespace_v1.actions_runner_system.metadata[0].name
    }
    "spec" = {
      "encryptedData" = {
        "github_app_id"              = "AgBg6eLC698WBqYZVkUVbiuxmNGkMJ21sSPuP4WbSsokcmaAijXNBPMV1qI0SddlAWyEmnL/i8Cs/LbO8DKOwHpiKQfi7MBahjmno5N07lrZ2bzjuh2+9KIHk1UTKspoE5VD0oBiNOOqCu1lV+Pmr8lWOe06WM6ZHqie2xSWwGnad6rQjxz3eG3fY09MjTM4dDLhv1mB2zrMQ2hHp81H4BemFcWtDyccIRElNK60tGXOMcFnofipapmvCI10W/vafH5IoUiW/nZEhB3RWmAgL97keIGLnnR5cpD2nPUo/pbIX+sgHUDOMT1nzpCgs/zEO07hUNMnDs2W0sE6t/6h+5/pcQbEq7vNhTJkIhSQXNmEPl026ZNx65z5T8mgvKa3zSOhOpMz34UQTuzRNRVoiZAe9tYYK17+7eWGrPsG7w8Z90z3e9MUmVjhvAgL6Vd6GTLYHLk4XzWdIYWc+855CfMPA+1iG8qiaSbduvK3qDd2QfEMqHSOVRoFRjd+3oF9ZtsVJeMJ6g14W7KDmO40N96iSBgBR/h9JcM9ZKqQHEuQvUmouUl1ehi/v5TkVzvJt4OYpMmb93+ziCH2YPmOIfSVBC3sjdvIt7u9nAm1KfAI0MXzdv0p7ADpC3dUXzFnNmb2zU9bH/1SPueDgOWQklssHacs8wYtEZ1saBY9oRnrK/NSrhOUTm2LW/SuyiXDnavVOO2giiE="
        "github_app_installation_id" = "AgBIqrr68ZaT/1LlYqHqoCzmAmiJ8zHQi8zkIjiodG36ErJlJRTX17IKklYaIkSivEZ0pC6oT3KmNCMcl4UHHc4bpnnZvU93Rw3ygy/vWg70ASLfncxLW3nYFQT/+Xvw0HVrAHb+EGrqk901JjlymbnSMmjHnkUMH6qEARbjzSZjdFeEp81xHFylnh4ObDdQudIyUMZNI2yvo9/4gOHyVmF4p5kKnkgtlvPnrd2zL6brg3H7t1ChRpbww51VthYlX6XfkYenzwPTmjqIagO7zba19EWobnqnJOPTaARAVy1KJQyVNINNLUy7a+soTFxNYqvFlfaOPDYNDU02CO2OHfBh2lKq6/3HY/D6T11frxAPAxJWIA2tKlLMUEGFJ+HrEFs2ECILRhF9JvKax5TRBG/mCjU7n3bJDQBiKwBGqPJNtWUsMf67uXlGcHEwHOIFfRSptFCG8/4h9paTeb+IhFB+3FcV02bKjku7RILDc2PojP1EwzbxaP7+HAR5ieSpprQuL/mQsZeE70CuM8Q4UH75yFtrouEDLItyVa2vLakU6ngiOKQ/sCk+jUzXLyeV7v4h3imkxzRFrmGiuojROMbuLC2glA5Sr7QmwRGr4vPsNWR6f5NHHStUmP9w1GhSkA9neCXNrsskmCLLhHlWdqyn39XpzVKd0J0E/AHN1ft0TVvrpZsxUoinw+izlB26LBv/M8UfhObnpQ=="
        "github_app_private_key"     = "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"
      }
    }
  }

  depends_on = [
    helm_release.sealed_secrets_controller,
  ]
}

resource "helm_release" "actions_runner_controller" {
  name      = "actions-runner-controller"
  namespace = kubernetes_namespace_v1.actions_runner_system.metadata[0].name

  repository = "https://actions-runner-controller.github.io/actions-runner-controller"
  chart      = "actions-runner-controller"
  version    = "0.17.3"

  depends_on = [
    helm_release.cert_manager_controller,
    kubernetes_manifest.controller_manager_sealed_secret,
  ]
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

resource "kubernetes_role_binding_v1" "github_actions_deployer_deploy" {
  metadata {
    name      = "github-actions-deployer-deploy"
    namespace = kubernetes_service_account_v1.github_actions_deployer.metadata[0].namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.deploy.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.github_actions_deployer.metadata[0].name
    namespace = kubernetes_service_account_v1.github_actions_deployer.metadata[0].namespace
  }
}

# FIXME: Depends on CRDs
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

  depends_on = [
    helm_release.actions_runner_controller,
    kubernetes_cluster_role_binding_v1.github_actions_deployer_view,
    kubernetes_role_binding_v1.github_actions_deployer_deploy,
  ]
}

# FIXME: Depends on CRDs
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

  depends_on = [
    helm_release.sealed_secrets_controller,
  ]
}

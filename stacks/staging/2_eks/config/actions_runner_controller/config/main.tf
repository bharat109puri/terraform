locals {
  runner_name       = "%{if var.env != ""}${var.env}-%{endif}k8s-deployer"
  runner_ssh_secret = join("-", [local.runner_name, "ssh"])
}

data "tfe_outputs" "kubernetes_config" {
  organization = "recrd"
  workspace    = "%{if var.env != ""}${var.env}_%{endif}kubernetes__config"
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
      "name"      = local.runner_name
      "namespace" = "default"
    }
    "spec" = {
      "replicas" = 1
      "template" = {
        "spec" = {
          "labels"             = [local.runner_name]
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
                "secretName"  = local.runner_ssh_secret
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
      "name"      = local.runner_ssh_secret
      "namespace" = kubernetes_manifest.runner_deployment.manifest.metadata["namespace"]
    }
    "spec" = {
      "encryptedData" = {
        ## TODO - need to check this id_rsa part
        "id_rsa"      = "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"
        "known_hosts" = "AgB/wdxPYx1q2Dwy9/ZIbu0sud1SkJIDNfNds/N6xtHlXGJBu/+Yy9E7wUFap0EYlYnqTtzxG81sNzA/M+1xap2HS0I50qcS+KYGzyjK32PhgaiaRbuWLo/Ayx3MqnzNtRY25/JyqajwUUiUXm6VWfcaYEiXRqKkU8ZXp20dSgYPPK04yE2k2HVRFCqNP/DrjmmIOYQb28Mb9FLPLQ36KHy3IJbLODt3L0PQxEQgomFoqxUmEHZplvoSqBaR0CPbto/MtNs7qy+trRum1x59EWFSA9ifQ8IttB6rATFWTH1cVzsMJTFRdH5eiIrjftOPYT2gDmVz1w0g+2rPPSQzYk+DJB2KpFrMMrdDtBrea+Lar5FNsq/Ovk/w1vxChQNQToDNXAYs1MXuhaZjG4kOtYeDx9Hu07T2SyPeQ66u3V524xkc+A+yVy9GVloNP+pndQkci1CwlSyRI0M5qkf2lWJy80rm/hhCL+KCVTt7W81+KQDEUuXeGzFBmNrw4SMN2eLPbmmY3jUoemQOUYVaTSxnn5GAc72L2zlAR3KEnRJpa8Ds6DMkKxZ5KpgwWrRXufPgz7SenfaZ4EL65uJlGk2yqh2BkGeSh2oBr18jWCQWDZ5r7YILiDk0L6eltD3HIvg1Ra5+bl8GjYsd43TpOuWZpqSSxsb7KMak32j+mPz12RSR2Y/KimxDFGAZX1jGVBTD7xq1v1bKiO+S0kDc+Wgu8DIO2l4Tsl5wDFXPUsBPmC7L8ssupN5sOfnwPXu04GqrrKb8ikwahq29r1Z+NUCC7cwf29FwZtjh4rn2nvbiI2nHEknwrPVIB9OqApoiha9zZzKIx1+AbDDSFixAUbbkcab6mi8Nq5IXOZYv0GgpSlIfbx5rnKEACsQLRU69E5cliSHqru0opOKYXRAfD2s3KN88Izy/9EPRl5oIHopQWJq2CUe1ijk+H2//h8EHFlcQbvlAM5TTGSqqB3WqrXciBjqroquMK+jMec0q/8+zPKKG+IFSASKOq7yTm9O5Y80AWYhqndKtgFSjgltifIfur71DdrfVcwN10fsosdU2kR7eXv0VzMIuLmgYuV+KXiv4tk6WYu3Y9pjN3AukMkYxeYlbc/kSmfJ+EueFKRDdDDhrW5SVQLEdrUi5LqFXOG7PNMP4pZ1p9Lu2VrwUu7BZbfFW52JUSR4cxqd0vgdgeHTZVmI1aqvEss6BzR4+MB1NIITbJ0GP"
      }
    }
  }
}

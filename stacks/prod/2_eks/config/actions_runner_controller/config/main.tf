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
        ## NOTE: Runner uses generated ssh key added to dmitry@recrd.com github account
        "id_rsa" = "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"
        ## NOTE: this value could be retrieved from command ssh-keyscan -t rsa github.com|aws-vault exec recrd/admin -- kubeseal --raw --name staging-k8s-deployer-ssh
        "known_hosts" = "AgBcrnAlegT+KTAdULCAuBYAPGvc+p/7mHFey5oXHBi7r2ZbHbtsk2x53R04GAAG/4aKq/G2Ue343ptqPtkpTBOG28knZPPY90wKYVQBCWLfByImbwcorFkx6VKNKJzrtec5T2GdJLtD45dQTFlHD4huJDF7RPcXZAfdRSX+U4njMZidZa3EkzM1lpyVbEFv7o/EFwxraU2KwZAQNnW9ShMe0lSObltr895VLFs2xJvzh3MSVGnPlOYK2fZJlXQ303Uzd9MCZVdsuXSEpd+WabpDhrz6WOFqEFRqU2qu8w/bDZktHxTiKdWvNrv3m7FLKR4UMvAIceZJpH2q8zQiwnu/4jJ4YjgC79wwQbPvlEoRleUuD5rBHzFZYyNrNH0e8p2wbCXe2GrfCyNHRfDJIXhwLP1XlWtDOuH2dCxfrby0A6/WxP4SwlaSUSERJTvbGBYJpnmLEjnSIVlyuN32ZROxLJjRVgBZT1jDpwmLmFPJZE6UwKU7/mzeIoe9ZHs8JAfqEGf7VzTRckb56elRUcdwNrNLa/85YQ2QWpNkCGU0tAMSyixg8iK/6ktVRZxqC5tvdBCurhEiGsH+nLNehdT4Aokzl5lJzBfwgQqsmaFgPuT2shVL+9Sds+zxMe4fRquG4hAk1Nductf6TyQekpCJ3MGflIp1I0WL1a22U3RuGW0rdlZ92YQwXE/yEJiGrW7m1ndfDvG5WZMLC5r/WBsITBrLqxloOSOD9xAozdEmrT0Lg+ThB/zZG5GYgovKgck455iZ8gBgKRfcbag6ndolACHFNiUDBAxGYdlRnsZB/rb8d+QRGUwkYcGRVVY5wHwLEMxAUStEUMe0y2QuSYkB0I1a/d0SyEkV6LZZYlECPY8cAifvk70S/zFemZ7Su316ZJRkC4++o7qB0aWjxYc9RbirULR90YHJX8kmxxDdZaeBYVO5XjZ2Q5JX1GIfj0OiyOFYJOVuHtUaaRTD764PQyr3rjmMtKMyVqjsw3cuPG+9kglrxehoGo2ZjXM4g/fB03kebyAmXIgTbDSc/ovFI/f9Nu4HlP+LMYCCJ/boSMh2F3Sr7qgLEOXK5YsMwHqWWaHfX7YI1WDEORqHErBAq3e8JgsTaVwk8Vzoy8qgY1T3FepJhFh44vYVk34c1dV/GnAOGOf5Q0eugLoK7ceyjSvRWXUS63fwlnbY7A0jpQhEJOcsiUiUFI7qjNPgRuRvbPJbzIUnsw=="
      }
    }
  }
}

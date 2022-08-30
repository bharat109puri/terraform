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
        "known_hosts" = "AgCPAZV8P+xk1GmrTUoyMz8vxLgBOcblsHwqk53FzTvvytm5WKiDm/Y/loU3tTFxoH9WNsDsiXVl+OFAGKmvTak9cECtuG1STQuttYDxDx1VVsltJOqYK31fLdDQRJcOHSKVxbUvmuaV164YLRrOu5YPxvni7kLS4+OsSrxhCEGwzq6z/g1s7Eip6/57LG2jzPXwp/WxKehk6Jtk+s+Kfl3mF9hbD/w0bZ/4dkzydLRQlQw+hA5Vtfh4rvulcxputqiYNRSdsuaapLQvSh7T1Ip+51Y9R/APBsXTXfNHxW1OccM70Wt2VurDimYQiEgogtIJ11K2AcXusjzgaMHdV8Up1WhLMKsLII1Z8l9IaIY3OPG2hj1Nb19dik0+qbVMXo/CjxFY5dQmLB6o4fkGMAg4D5nwNGdt0m/ro+CfO0tZU+tKvDxML5eAzFmvJiMaQ8DqyihvSv06Hr/ZgUQ7LW3AhBt9BN1lwQFQX5YKQAU6Yw4YzFxNQzugqGMaajJsAHBCVjCnRlpb3LDb+arZzNSLGHpweepGAi6tsbXlQD+QSLrBaRq+zSeQ/QdFGS+MHE7GPWk85CUpAro5c9GCJf5dInn6N4z4Db4xPP1qMYm/Nq+DuVzF2LRD2wvTo4VerQU4BHwUPGpHm2zjwh9Jijvg9RGJQf3MO7214X65oBh/S7pFrfi9EeoxCtj3BWJGspG9MCUUQvfWx+d5JkyLBE2XFXeNMcFVKM4b5mr/02lFPGtQOG65+f/3//A+ZG8cvC0+yi59OYKwGwcjC7pdQbbqFlULUfStzMoz5HyaLz3kGSLJ46lRcEKmB6YbOngU7X//jDSk7BsuWDv/2YsjTX3LoKvshyLWbc+0avSxV3T3UghQGtAv9HxsizHGWRP98Fe1AinHvCWvam+2eoVVX3lZ+LNc8v2xtFFFIFO47s9yRc7Vvz6v40XRDM4VUBqmcjL6QNktuZuC/2kB3cSuBlZkRNhGB9nYd1eOpCxpcy98/btxeEc3iFhVwITKr5gmlwoXJmoSdGwV/dNUrhbdHRKo/NsZR/wErD19bisA2LGXquPdy/1EqmTOL++MIJoob+72Q1p9x31ETZTKbX2LsZGl1yVWE/TM7ZUqMqyH04PjAr/qliiyrd5yE+t3SFcD582DUKxJEghHUMPeC7DcfZI/qTqX753nWjMHPZYGl7oeW9mVZtpaz2ZO2vZgJb+79HLA4AT4zwzBIm+z5oEw74s/EKnVzxvYCtH0zdoVTcDDDXOTv+GaATPe6277LrIOXPsQXgy8OPFFURsxNnV8GCRVjFJO9QSR6EFB8lg1JLDjdScuGxPq28eD2ZmaXrzyAQ/jQAS92n57ab8UCqxxvedgKygatFqDLl1sip7rtwzEPfdX1hLxMtEod8u0Iqin5hTOCImMu93MCCtVTzXpft/sj1fU5p/5zctbhWa2DtKlhw7imHK9g+lW9yxyGfF9bZmZQMw3m12npOx3F3uyjbF/jejt0N00g9789x/AMTNdoIAgUc/6xu+QSXQrOzBdU//1+z+TWD25J83nsVWULnfjAThJz/HzrjR9jnaj9KR55wcAmWul+GYt7Hz3pXLGhImQ1wpCIj2iVc0FQv91kjglZH5d8gz8BaZl1+XceLj7vwfh0RE3rJmFFM98Bc4LHouel/lL2RHSKMVRWPnPJrqI"
      }
    }
  }
}

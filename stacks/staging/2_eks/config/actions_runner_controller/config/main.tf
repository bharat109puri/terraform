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
        "known_hosts" = "AgA9Koyr4qvw478lhkCdFsvx0glzDG6L/YyXCagPRA0QknAwm8BXKSPRdb0aGHUul8ZclV1g94VNGhJqxILF5Uzyr3qkCS8vTmna8cLd8UzGg+jt4CtWAvlQqJ8zSIhD8edrfggbvLuvG81r86Ym8veeq7XBiLDGNkkPfugIUAwjG6Z1Cj95Qi82hoKPBl88FyOJ2FNVQGpv/7G+Q84pmVKmn4d6vz7hyQFL8sqI6Tg+lW1KXQnEgkLsQd5W5kBsnQcCPactybqUIjiy6rmVASmXDPlT5vPDJBRH/fqqpsgtMM0pX9XCW3cF/d48lMAC4ob+jpzAKlInQyoeW78LYH7XWlo3OXLYf45Hggikf1coGvKSWl/Y1qO7eclIPXEQb80adz98gMgYlNwju+OySqh2GaUerQUlzTXhFXkXKBNjn4GYEuqw4M4Wp86Ivp6QjHiqTbrTPKDI/NPjQcoMLstvc2Jw/3GhC2+TtxJ1zuKddfrZ+eAiHo+G2sKc+ferU9OKPk4nK4i2uTewi2dOJ+8BPrOZLpSf51fnheDKXCwd3OhUw7IVTtKk8aVq0PFPyn1Zh8L5pNUNj30XtnG4FSZhtJwo0PGhxy+rW0KQfexq1IKm1J6J+IBmucLqsTauGy7qPUOXu4XsXyZEmDgmWf6fTpH806hF1wdw/IXpP5Au+F9H4sHTavAmS6Sg97caEeOy/8rYaylLqUklokRk+5ava15ygPyFPGBFXz/uYfcAXA97HW91JMTh1nco2liMzXetirz9gSGyTCQcaQ+KUEKhylBGp6mWJWEk2bbNIUrFHuSEA7zQ9hzNKVIFPcYeYtPaqfN36X2lq8qqlw6gBh9pNodlPIf0nzqvKIxzWjDfFPtClQmTHrrnKuwXFo/zfXHSPIcXqijvs48nHcsw+7Zj5BaBWq7oUNX4PXEw5XzOgopSS1VTkAgrKG2+3y4IN7CeB4nto/UgIGw4sJD+ltez56H2rMLG2b1r2V+bhj+mZHFyig0H1YmDGTuIgD4ILr5RcRGXhkFj9Y9U4ewfyUag8tWtxfyFmE9vmlMXuNDKIbTrbhgqlBZe4maLXwXOTxQcQqOAhq6LNqmn0wbgClc09G/ESGmI6y/9radqbGNiEJ6UrpVbkInINBTTBnNdude/IsB4/+mkUbmxoUlyjSvafJ2fh50vnPCGLVfnBesRq55xPPZgl1LS86/f3inDvVjCsESOSJecyA=="
      }
    }
  }
}

locals {
  ecr_repo_actions = [
    "ecr:BatchCheckLayerAvailability",
    "ecr:BatchGetImage",
    "ecr:CompleteLayerUpload",
    "ecr:DescribeImages",
    "ecr:DescribeRepositories",
    "ecr:GetDownloadUrlForLayer",
    "ecr:GetRepositoryPolicy",
    "ecr:InitiateLayerUpload",
    "ecr:ListImages",
    "ecr:PutImage",
    "ecr:UploadLayerPart",
  ]

  services = toset([
    "angara",
    "congo",
    "danube",
    "elba",
    "hello-world",
    "indus",
    "nile",
    "recrd-cli",
    "musi",
    "lena-micro-services"
    "echo"
  ])
}

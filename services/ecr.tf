locals {
  services = toset([
    "angara",
    "congo",
    "danube",
    "indus",
    "nile",
  ])
}

# TODO: Generate together with workspace?
resource "aws_ecr_repository" "services" {
  for_each = local.services

  name = each.value

  image_tag_mutability = "MUTABLE" # TODO: Do we want mutable tags?

  encryption_configuration {
    encryption_type = "AES256" # TODO: Do we need KMS for replication?
  }
}

locals {
  cors_rule = [{
    allowed_headers = ["*"]
    allowed_methods = [
      "GET",
      "POST",
      "PUT",
      "HEAD",
    ]
    allowed_origins = [
      "https://recrd.com",
      "http://localhost:3000",
      "https://web-frontend-staging.recrd.com",
      "https://web-frontend.recrd.com",
      "https://recrd.webrexstudio.com"
    ]
    expose_headers = [
      "Access-Control-Allow-Origin"
    ]
    max_age_seconds = 3000
  }]
}

data "tfe_outputs" "bootstrap" {
  organization = "recrd"
  workspace    = "bootstrap"
}

data "tfe_outputs" "users" {
  organization = "recrd"
  workspace    = "users"
}

module "frontend" {
  source = "git@github.com:RecrdGroup/terraform.git//modules/distributed_content?ref=master"

  name    = "web-frontend"
  aliases = ["recrd.com", "www.recrd.com"]
  zone_id = data.tfe_outputs.bootstrap.values.recrd_com_public_zone_id

  cors_rule = local.cors_rule

  providers = {
    aws.us-east-1 = aws.us-east-1
  }
}

module "frontend_staging" {
  source = "git@github.com:RecrdGroup/terraform.git//modules/distributed_content?ref=master"

  name    = "web-frontend-staging"
  zone_id = data.tfe_outputs.bootstrap.values.recrd_com_public_zone_id

  allowed_cidr_blocks = formatlist("%s/32", nonsensitive(data.tfe_outputs.bootstrap.values.nat_public_ips))
  cors_rule           = local.cors_rule

  providers = {
    aws.us-east-1 = aws.us-east-1
  }
}

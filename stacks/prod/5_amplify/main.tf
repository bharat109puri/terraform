## portal ##

resource "aws_amplify_app" "portal" {
  name       = "portal"
  repository = "https://github.com/RecrdGroup/portal"
  #  default_domain              = "d1n6r2i9eyduzu.amplifyapp.com"
  enable_auto_branch_creation = false
  enable_basic_auth           = false
  enable_branch_auto_build    = false
  enable_branch_auto_deletion = false
  # The default build_spec added by the Amplify Console for React.
  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - yarn install
        build:
          commands:
            - yarn run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
		EOT

  environment_variables = {
    "REACT_APP_BASE_URL"         = "https://api.recrd.com"
    "REACT_APP_GOOGLE_CLIENT_ID" = "17226805587-tipon5rdh1jqr06m0e17rj4ag74lknng.apps.googleusercontent.com"
    "REACT_APP_MUSI_BASE_URL"    = "https://api.recrd.com"
    "REACT_APP_PORTAL_NODE_ENV"  = "development"
    "_LIVE_UPDATES" = jsonencode(
      [
        {
          pkg     = "node"
          type    = "nvm"
          version = "16"
        },
      ]
    )
  }
  iam_service_role_arn = "arn:aws:iam::378942204220:role/amplifyconsole-backend-role"

  #  production_branch = [
  #    {
  #      branch_name      = "master"
  #      last_deploy_time = "2022-10-17T08:55:55Z"
  #      status           = "SUCCEED"
  #      thumbnail_url    = "https://aws-amplify-prod-eu-west-1-artifacts.s3.eu-west-1.amazonaws.com/d1n6r2i9eyduzu/master/SCREENSHOTS/thumbnail.png?X-Amz-Security-Token=IQoJb3JpZ2luX2VjEDsaCWV1LXdlc3QtMSJIMEYCIQDSASGA%2BaAV3rujKnwzf762hbEES%2BxIRQHiV5dFMpCdSQIhAOOngwdhtIR5NZenOyQVPHo2vcw8ZIBa7MJFNmlp9z2MKsEDCBQQAxoMNTY1MDM2OTI2NjQxIgwIuf2f5HXB6quBOW8qngPfHY%2BSbc1dcmaJduM%2BC7Gp1zCEuOfdbQyPLSpRuUkmdfnYTztwIWDwxeknzLhnlNM3W6QGGSLCsnVspWV1c8Fh6zt9pGFOFT4kLGMKKd3SW7Jp4RbEK67JijGQIhHMRx6z7PknLnvavWaOkREZ4SCIrZ1tyVhWQzdz%2FV2Id5J4wRezEyV8FoZiHpy31yiqltjBOU6nV57ieP9wW3p1aL2LebVALGLjZLeOYdz2iU84dyb6oiLvuAd5%2BFxNFysDeeYz1DiNibejUppUupDjY0FKJF973Bu7vya6oLnPpqH8j1XgZl8bHfZGXeIXQeiy8ltsVFHJjVCxzGq7PdFfQdajAzIl4QQqshB6ysVRHln3SD01VZTRfWOMIxRnXD9yl5nkxcqBbmduhzuzccN4jWjscuOmWwj5EqJIv5dtqwu6mtwuxCQDMpiyHDDvEVDN1SWqSRYG9sgHRHQJtIJjuqS3SNns4CWh70lUtnT87AjIlfmIGHReoEAHqHW%2BOZxjhwmzLOmTFolW3CECQziqBYM9BmSqF7hO3%2B%2BddhiiuTAw7OG0mgY6nQEYADjokKNnkUORmI1YYqedEnuYVRuOuc1%2F1xWnUFTm1y5td441Pzd3VhYG5okK2NzPkRUKCmKU1QCYczTjNdkzEF68M4mwXjuQj7GLt7QoSRR5DNkcs3q7BKIpvHG2iON7qYPa9jqD2%2F55nYaZOgOycIZP%2Br7qWre7OawTh1a573L0DvD1oG%2BaesyymyVj8%2Bhbve2plKHrZ71D0eWk&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20221017T114019Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Credential=ASIAYHDWTI2YSYZQZL7C%2F20221017%2Feu-west-1%2Fs3%2Faws4_request&X-Amz-Signature=df61ff1f5921bfe88a04259d1cc91e74a3a9d34ece5c78a5731173cd18948f6c"
  #    },
  #  ]

  custom_rule {
    source = "/<*>"
    target = "/index.html"
    status = "404-200"
  }

  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|ttf|map|json)$)([^.]+$)/>"
    target = "/index.html"
    status = "200"
  }

}

###################### amplify branches #######################

resource "aws_amplify_branch" "master" {
  app_id      = aws_amplify_app.portal.id
  branch_name = "master"
  environment_variables = {
    REACT_APP_PORTAL_NODE_ENV = "production"
  }
  framework = "React"
  # id        = "d1n6r2i9eyduzu/master"
  stage = "PRODUCTION"
  tags  = {}

}


resource "aws_amplify_branch" "staging" {
  app_id      = aws_amplify_app.portal.id
  branch_name = "staging"
  environment_variables = {
    REACT_APP_PORTAL_NODE_ENV = "staging"
  }
  # id        = "d1n6r2i9eyduzu/staging"
  tags = {}

}


###################### amplify domains #######################

resource "aws_amplify_domain_association" "example" {
  app_id      = aws_amplify_app.example.id
  domain_name = "example.com"

  # https://example.com
  sub_domain {
    branch_name = aws_amplify_branch.master.branch_name
    prefix      = ""
  }

  # https://www.example.com
  sub_domain {
    branch_name = aws_amplify_branch.master.branch_name
    prefix      = "www"
  }
}
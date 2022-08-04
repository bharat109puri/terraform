resource "aws_api_gateway_authorizer" "demo" {
  name                   = "demo"
  rest_api_id            = aws_api_gateway_rest_api.demo.id
  authorizer_uri         = aws_lambda_function.authorizer.invoke_arn
  authorizer_credentials = aws_iam_role.invocation_role.arn
}

resource "aws_iam_role" "invocation_role" {
  name = "api_gateway_auth_invocation"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "invocation_policy" {
  name = "default"
  role = aws_iam_role.invocation_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "lambda:InvokeFunction",
      "Effect": "Allow",
      "Resource": "${aws_lambda_function.authorizer.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda" {
  name = "demo-lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "authorizer" {
  filename      = "../authorizer/out/lambda-function.zip"
  function_name = "api_gateway_authorizer"
  role          = aws_iam_role.lambda.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  source_code_hash = filebase64sha256("../authorizer/out/lambda-function.zip")
}


resource "aws_api_gateway_rest_api" "demo" {
  name        = "auth-demo"
  description = "This is my API for demonstration purposes"
}

resource "aws_api_gateway_method" "any_authorized" {
  rest_api_id   = aws_api_gateway_rest_api.demo.id
  resource_id   = aws_api_gateway_resource.authorized.id
  http_method   = "ANY"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.demo.id
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_method" "any_unauthorized" {
  rest_api_id   = aws_api_gateway_rest_api.demo.id
  resource_id   = aws_api_gateway_resource.unauthorized.id
  http_method   = "ANY"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_resource" "authorized" {
  rest_api_id = aws_api_gateway_rest_api.demo.id
  parent_id   = aws_api_gateway_rest_api.demo.root_resource_id
  path_part   = "authorized"
}

resource "aws_api_gateway_resource" "unauthorized" {
  rest_api_id = aws_api_gateway_rest_api.demo.id
  parent_id   = aws_api_gateway_rest_api.demo.root_resource_id
  path_part   = "unauthorized"
}

resource "aws_api_gateway_deployment" "dev" {
  rest_api_id = aws_api_gateway_rest_api.demo.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.authorized.id,
      aws_api_gateway_method.any_authorized.id,
      aws_api_gateway_integration.authorized.id,
      aws_api_gateway_resource.unauthorized.id,
      aws_api_gateway_method.any_unauthorized.id,
      aws_api_gateway_integration.unauthorized.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.dev.id
  rest_api_id   = aws_api_gateway_rest_api.demo.id
  stage_name    = "dev"
}

resource "aws_api_gateway_integration" "authorized" {
  rest_api_id          = aws_api_gateway_rest_api.demo.id
  resource_id          = aws_api_gateway_resource.authorized.id
  http_method          = aws_api_gateway_method.any_authorized.http_method
  integration_http_method = "POST"
  type                 = "HTTP_PROXY"
  timeout_milliseconds = 29000
  uri =  var.rest_api_authenticated_http
  request_parameters = {
    "integration.request.header.x-recrd-user": "context.authorizer.user",
    "integration.request.header.x-recrd-anonymus": "context.authorizer.anonymus"
  }
}

resource "aws_api_gateway_integration" "unauthorized" {
  rest_api_id          = aws_api_gateway_rest_api.demo.id
  resource_id          = aws_api_gateway_resource.unauthorized.id
  http_method          = aws_api_gateway_method.any_unauthorized.http_method
  integration_http_method = "POST"
  type                 = "HTTP_PROXY"
  timeout_milliseconds = 29000
  uri =  var.rest_api_unauthenticated_http
}

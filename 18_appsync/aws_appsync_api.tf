resource "aws_appsync_graphql_api" "demo" {
  name                = "DemoApi"
  authentication_type = "API_KEY"
  schema              = file("demo_api.graphql")
  xray_enabled        = true

  log_config {
    cloudwatch_logs_role_arn = aws_iam_role.cloud_watch_logs.arn
    field_log_level          = "ERROR"
  }
}

resource "aws_appsync_api_key" "demo" {
  api_id      = aws_appsync_graphql_api.demo.id
  description = "API Key for the Demo"
  expires     = timeadd(timestamp(), "160h")
  lifecycle {
    ignore_changes = [
      expires
    ]
  }
}
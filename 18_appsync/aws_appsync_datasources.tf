resource "aws_appsync_datasource" "users" {
  api_id           = aws_appsync_graphql_api.demo.id
  name             = aws_dynamodb_table.users.name
  service_role_arn = aws_iam_role.appsync_role.arn
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = aws_dynamodb_table.users.name
  }
}

resource "aws_appsync_datasource" "offices" {
  api_id = aws_appsync_graphql_api.demo.id
  name   = var.rds_db_name
  service_role_arn = aws_iam_role.appsync_role.arn
  type   = "RELATIONAL_DATABASE"

  relational_database_config {
    http_endpoint_config {
      db_cluster_identifier = aws_rds_cluster.offices.arn
      aws_secret_store_arn  = aws_secretsmanager_secret.db_password_key.arn
      database_name         = aws_rds_cluster.offices.database_name
      #      schema = ""
    }
  }
}
output "aws_appsync_api_key" {
  value     = aws_appsync_api_key.demo.key
  sensitive = true
}

output "aws_appsync_graphql_api_url" {
  value = aws_appsync_graphql_api.demo.uris["GRAPHQL"]
}

output "aws_rds_host" {
  value = aws_rds_cluster.offices.endpoint
}

output "aws_rds_user" {
  value = aws_rds_cluster.offices.master_username
}

output "aws_rds_password" {
  value     = aws_rds_cluster.offices.master_password
  sensitive = true
}

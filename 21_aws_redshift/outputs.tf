output "bastion_instance_id" {
  value = aws_instance.bastion.id
}

output "redshift_cluster_endpoint" {
  value = aws_redshift_cluster.bigdata.endpoint
}

output "redshift_cluster_db_name" {
  value     = aws_redshift_cluster.bigdata.database_name
  sensitive = true
}

output "redshift_cluster_db_user" {
  value     = aws_redshift_cluster.bigdata.master_username
  sensitive = true
}

output "redshift_cluster_db_password" {
  value     = aws_redshift_cluster.bigdata.master_password
  sensitive = true
}
resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = format(local.resource_name, var.redshift_cluster_settings.subnet_group_name)
  subnet_ids = [for subnet in aws_subnet.data : subnet.id]

  tags = {
    Name = format(local.resource_name, var.redshift_cluster_settings.subnet_group_name)
  }
}

resource "aws_redshift_cluster" "bigdata" {
  cluster_identifier        = format(local.resource_name, var.redshift_cluster_settings.name)
  cluster_type              = "single-node"
  publicly_accessible       = false
  skip_final_snapshot       = true
  node_type                 = var.redshift_cluster_settings.node_type
  number_of_nodes           = var.redshift_cluster_settings.node_count
  iam_roles                 = [aws_iam_role.redshift_role.arn]
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.name
  vpc_security_group_ids    = [aws_security_group.redshift_sg.id]
  database_name             = aws_ssm_parameter.redshift_db_name.value
  master_username           = aws_ssm_parameter.redshift_db_user.value
  master_password           = aws_ssm_parameter.redshift_db_password.value

  tags = {
    Name = format(local.resource_name, var.redshift_cluster_settings.name)
  }
}

resource "aws_ssm_parameter" "redshift_db_name" {
  name  = format("/%s/%s", local.param_store_prefix, "db/name")
  type  = "String"
  value = var.redshift_db_name

  tags = {
    Name = format(local.resource_name, "redshift-db-name")
  }
}

resource "aws_ssm_parameter" "redshift_db_user" {
  name  = format("/%s/%s", local.param_store_prefix, "db/user")
  type  = "String"
  value = var.redshift_db_user

  tags = {
    Name = format(local.resource_name, "redshift-db-user")
  }
}

resource "aws_ssm_parameter" "redshift_db_password" {
  name  = format("/%s/%s", local.param_store_prefix, "db/password")
  type  = "SecureString"
  value = random_password.db_password.result

  tags = {
    Name = format(local.resource_name, "redshift-db-password")
  }
}

resource "random_password" "db_password" {
  length      = 16
  min_lower   = 4
  min_upper   = 4
  min_numeric = 2
  min_special = 2
}
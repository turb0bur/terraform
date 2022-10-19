resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers          = {
    keeper_1 = var.rds_user
  }
}

provider "aws" {}

resource "aws_ssm_parameter" "rds_password" {
  name        = var.ssm_rds_password_key
  description = "Password for RDS database"
  type        = "SecureString"
  value       = random_password.password.result

  depends_on = [random_password.password]
}

resource "aws_db_instance" "rds" {
  identifier           = "prod-rds"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = var.rds_user
  password             = data.aws_ssm_parameter.rds_password.value
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
}

output "rds_random_password" {
  value     = random_password.password.result
  sensitive = true
}


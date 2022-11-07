resource "random_password" "db_master_password" {
  length  = 16
  special = true
  keepers = {
    keeper_1 = var.rds_user
  }
}

resource "aws_secretsmanager_secret" "db_password_key" {
  name = "appsync-demo-rds-password-3"
}

resource "aws_secretsmanager_secret_version" "db_password_value" {
  secret_id     = aws_secretsmanager_secret.db_password_key.id
  secret_string = jsonencode(
    {
      username = aws_rds_cluster.offices.master_username
      password = aws_rds_cluster.offices.master_password
      engine   = "mysql"
      host     = aws_rds_cluster.offices.endpoint
    }
  )
}

resource "aws_rds_cluster" "offices" {
  engine                 = "aurora-mysql"
  engine_version         = "5.7.mysql_aurora.2.07.1"
  engine_mode            = "serverless"
  database_name          = var.rds_db_name
  master_username        = var.rds_user
  master_password        = random_password.db_master_password.result
  enable_http_endpoint   = true
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_default_security_group.default.id]
  scaling_configuration {
    min_capacity = 1
  }
  lifecycle {
    ignore_changes = [
      engine_version,
    ]
  }
  tags = {
    Name = "${var.rds_db_name}_rds_cluster"
  }
}

resource "aws_default_vpc" "default" {}
resource "aws_default_security_group" "default" {
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
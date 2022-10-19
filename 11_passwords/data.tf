data "aws_ssm_parameter" "rds_password" {
  name = var.ssm_rds_password_key

  depends_on = [aws_ssm_parameter.rds_password]
}

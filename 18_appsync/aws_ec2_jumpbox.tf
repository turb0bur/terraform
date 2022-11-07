resource "aws_default_subnet" "default" {
  availability_zone = "eu-west-2a"
}

module "session_manager" {
  source        = "git::https://github.com/BardiaN/terraform-aws-session-manager.git?ref=2.0.2"
  name          = "appsync-rds-jump-box"
  instance_type = "t3.micro"

  subnet_id              = aws_default_subnet.default.id
  vpc_id                 = aws_default_vpc.default.id
  vpc_security_group_ids = [aws_default_security_group.default.id]
  ssm_document_name      = "AppSync-RDS-SSM-SessionManagerRunShell"
}
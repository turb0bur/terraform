resource "aws_security_group" "bastion_sg" {
  name        = format(local.resource_name, var.bastion_sg_settings.name)
  description = var.bastion_sg_settings.description
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = format(local.resource_name, var.bastion_sg_settings.name)
  }
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ingress" {
  description       = "Allow SSM traffic"
  security_group_id = aws_security_group.bastion_sg.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = format(local.resource_name, "ssm-access")
  }
}

resource "aws_vpc_security_group_egress_rule" "bastion_egress" {
  security_group_id = aws_security_group.bastion_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "redshift_sg" {
  name        = format(local.resource_name, var.redshift_sg_settings.name)
  description = var.redshift_sg_settings.description
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = format(local.resource_name, var.redshift_sg_settings.name)
  }
}

resource "aws_vpc_security_group_ingress_rule" "redshift_ingress" {
  description                  = "Allow Redshift access"
  security_group_id            = aws_security_group.redshift_sg.id
  referenced_security_group_id = aws_security_group.bastion_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 5439
  to_port                      = 5439

  tags = {
    Name = format(local.resource_name, "redshift-access")
  }
}

resource "aws_vpc_security_group_egress_rule" "redshift_egress" {
  security_group_id = aws_security_group.redshift_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
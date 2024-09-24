resource "aws_security_group" "nat_sg" {
  vpc_id = aws_vpc.main.id
  name   = var.nat_sg_settings.name

  tags = {
    Name = format(local.resource_name, var.nat_sg_settings.name)
  }
}

resource "aws_vpc_security_group_ingress_rule" "default" {
  security_group_id = aws_security_group.nat_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "default" {
  security_group_id = aws_security_group.nat_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "public_alb_sg" {
  vpc_id = aws_vpc.main.id
  name   = var.public_alb_sg_settings.name

  tags = {
    Name = format(local.resource_name, var.public_alb_sg_settings.name)
  }
}

resource "aws_vpc_security_group_ingress_rule" "http_public" {
  security_group_id = aws_security_group.public_alb_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "default_public" {
  security_group_id = aws_security_group.public_alb_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "petclinic_sg" {
  vpc_id = aws_vpc.main.id
  name   = var.private_instances_sg_settings.name

  tags = {
    Name = format(local.resource_name, var.private_instances_sg_settings.name)
  }
}

resource "aws_vpc_security_group_ingress_rule" "icmp_private" {
  security_group_id = aws_security_group.petclinic_sg.id
  from_port         = -1
  to_port           = -1
  ip_protocol       = "icmp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "petclinic_alb_sg" {
  security_group_id            = aws_security_group.petclinic_sg.id
  referenced_security_group_id = aws_security_group.public_alb_sg.id
  from_port                    = 32768
  to_port                      = 65535
  ip_protocol                  = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "https_for_ssm" {
  security_group_id = aws_security_group.petclinic_sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "default_private" {
  security_group_id = aws_security_group.petclinic_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
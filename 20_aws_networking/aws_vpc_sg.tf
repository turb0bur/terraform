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

resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.main.id
  name   = var.public_sg_settings.name

  tags = {
    Name = format(local.resource_name, var.public_sg_settings.name)
  }
}

resource "aws_vpc_security_group_ingress_rule" "http_public" {
  security_group_id = aws_security_group.public_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "default_public" {
  security_group_id = aws_security_group.public_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.main.id
  name   = var.private_sg_settings.name

  tags = {
    Name = format(local.resource_name, var.private_sg_settings.name)
  }
}

resource "aws_vpc_security_group_ingress_rule" "icmp_private" {
  security_group_id = aws_security_group.private_sg.id
  from_port         = -1
  to_port           = -1
  ip_protocol       = "icmp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "https_for_ssm" {
  security_group_id = aws_security_group.private_sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "default_private" {
  security_group_id = aws_security_group.private_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
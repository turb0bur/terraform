
resource "aws_security_group" "nat_sg" {
  vpc_id = aws_vpc.main.id
  name   = var.nat_sg_settings.name

  tags = {
    Name = local.nat_sg_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "default" {
  for_each          = aws_subnet.private
  security_group_id = aws_security_group.nat_sg.id
  ip_protocol       = var.nat_sg_settings.ingress.default.protocol
  cidr_ipv4         = each.value.cidr_block
}

resource "aws_vpc_security_group_egress_rule" "default" {
  security_group_id = aws_security_group.nat_sg.id
  ip_protocol       = var.nat_sg_settings.egress.default.protocol
  cidr_ipv4         = var.nat_sg_settings.egress.default.cidr_block
}

resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.main.id
  name   = var.public_sg_settings.name

  tags = {
    Name = local.public_sg_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_public" {
  for_each          = aws_subnet.private
  security_group_id = aws_security_group.public_sg.id
  from_port         = var.public_sg_settings.ingress.ssh.from_port
  to_port           = var.public_sg_settings.ingress.ssh.to_port
  ip_protocol       = var.public_sg_settings.ingress.ssh.protocol
  cidr_ipv4         = each.value.cidr_block
}

resource "aws_vpc_security_group_ingress_rule" "http_public" {
  security_group_id = aws_security_group.public_sg.id
  from_port         = var.public_sg_settings.ingress.http.from_port
  to_port           = var.public_sg_settings.ingress.http.to_port
  ip_protocol       = var.public_sg_settings.ingress.http.protocol
  cidr_ipv4         = var.public_sg_settings.ingress.http.cidr_block
}

resource "aws_vpc_security_group_egress_rule" "default_public" {
  security_group_id = aws_security_group.public_sg.id
  ip_protocol       = var.public_sg_settings.egress.default.protocol
  cidr_ipv4         = var.public_sg_settings.egress.default.cidr_block
}

resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.main.id
  name   = var.private_sg_settings.name

  tags = {
    Name = local.private_sg_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_private" {
  security_group_id            = aws_security_group.private_sg.id
  from_port                    = var.private_sg_settings.ingress.ssh.from_port
  to_port                      = var.private_sg_settings.ingress.ssh.to_port
  ip_protocol                  = var.private_sg_settings.ingress.ssh.protocol
  referenced_security_group_id = aws_security_group.public_sg.id
}

resource "aws_vpc_security_group_ingress_rule" "icmp_private" {
  for_each          = aws_subnet.public
  security_group_id = aws_security_group.private_sg.id
  from_port         = var.private_sg_settings.ingress.icmp.from_port
  to_port           = var.private_sg_settings.ingress.icmp.to_port
  ip_protocol       = var.private_sg_settings.ingress.icmp.protocol
  cidr_ipv4         = each.value.cidr_block
}

resource "aws_vpc_security_group_ingress_rule" "https_for_ssm" {
  for_each          = aws_subnet.private
  security_group_id = aws_security_group.private_sg.id
  from_port         = var.private_sg_settings.ingress.https.from_port
  to_port           = var.private_sg_settings.ingress.https.to_port
  ip_protocol       = var.private_sg_settings.ingress.https.protocol
  cidr_ipv4         = each.value.cidr_block
}

resource "aws_vpc_security_group_egress_rule" "default_private" {
  security_group_id = aws_security_group.private_sg.id
  ip_protocol       = var.private_sg_settings.egress.default.protocol
  cidr_ipv4         = var.private_sg_settings.egress.default.cidr_block
}
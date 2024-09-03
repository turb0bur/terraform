locals {
  services = {
    "ec2messages" : {
      "name" : "com.amazonaws.${var.region}.ec2messages"
      "tags" : {
        "Name" : "ec2-messages-endpoint"
      }
    },
    "ssm" : {
      "name" : "com.amazonaws.${var.region}.ssm"
      "tags" = {
        "Name" : "ssm-endpoint"
      }
    },
    "ssmmessages" : {
      "name" : "com.amazonaws.${var.region}.ssmmessages"
      "tags" = {
        "Name" : "ssm-messages-endpoint"
      }
    }
  }
}

resource "aws_vpc_endpoint" "ssm_services" {
  for_each            = local.services
  vpc_id              = aws_vpc.main.id
  service_name        = each.value.name
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.private_sg.id]
  private_dns_enabled = true
  ip_address_type     = "ipv4"
  subnet_ids          = [for subnet in aws_subnet.private : subnet.id]

  tags = {
    Name = each.value.tags.Name
  }
}
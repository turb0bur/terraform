provider "aws" {
  region = var.region
}

resource "aws_instance" "my_server" {
  ami = data.aws_ami.latest_linux.id
  instance_type = var.instance_type
  security_groups = [aws_security_group.web.name]
  monitoring = var.enable_detailed_monitoring
  tags = merge(var.common_tags, {
    Name = "My ${var.common_tags.Environment} server"
  })
}

resource "aws_security_group" "web" {
  name        = "Web Server SG"
  vpc_id      = aws_default_vpc.my_vpc.id
  description = "Security group for EC2 instance"

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags,{
    Name = "EC2 Security Group"
  })
}

resource "aws_default_vpc" "my_vpc" {}

resource "aws_eip" "web_server_elastic_ip" {
  instance = aws_instance.my_server.id
  tags = merge(var.common_tags, {
    Name = "EIP for EC2 instance on ${var.common_tags.Environment}"
    Project = local.project_name
    Zones = local.az_list
  })
}

data "aws_availability_zones" "available" {}

locals {
  project_name = "${var.common_tags.Environment}-${var.common_tags.Project}"
  az_list = join(", ", data.aws_availability_zones.available.names)
}
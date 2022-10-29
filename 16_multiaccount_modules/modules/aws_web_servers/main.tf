terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [
        aws.dev,
        aws.test,
        aws.prod
      ]
    }
  }
}

resource "aws_instance" "dev_server" {
  provider      = aws.dev
  ami           = data.aws_ami.latest_ubuntu20_dev.id
  instance_type = var.instance_type
  tags          = {
    Name = "Dev server"
  }
}

resource "aws_instance" "test_server" {
  provider      = aws.test
  ami           = data.aws_ami.latest_ubuntu20_test.id
  instance_type = var.instance_type
  tags          = {
    Name = "Test server"
  }
}

resource "aws_instance" "prod_server" {
  provider      = aws.prod
  ami           = data.aws_ami.latest_ubuntu20_prod.id
  instance_type = var.instance_type
  tags          = {
    Name = "Prod server"
  }
}

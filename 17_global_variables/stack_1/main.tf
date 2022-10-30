provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "butko-terraform-learning-course"
    key    = "dev/global_vars/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  company_name = data.terraform_remote_state.global.outputs.company_name
  common_tags = data.terraform_remote_state.global.outputs.tags
}

resource "aws_vpc" "vpc_1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Stack1-VPC1"
    Company = local.company_name
    Owner = local.common_tags.Owner
  }
}

resource "aws_vpc" "vpc_2" {
  cidr_block = "10.10.0.0/16"
  tags = merge(local.common_tags, {
    Name = "Stack1-VPC2"
  })
}
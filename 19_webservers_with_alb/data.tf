data "aws_caller_identity" "current" {}

data "aws_vpc" "default" {
  default = true
}

# Retrieve availability zones for the region
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

provider "aws" {}

data "aws_security_group" "available_sg" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpcs" "my_vpcs" {}
data "aws_vpc" "default" {}

resource "aws_subnet" "my_vpc_subnet_1" {
  vpc_id = data.aws_vpc.default.id
  cidr_block = "172.31.64.0/20"

  tags = {
    Name = "Subnet 1 of ${data.aws_vpc.default.id}"
    Account = "Subnet in account ${data.aws_caller_identity.current.account_id}"
    Region = "Subnet in region ${data.aws_region.current.description}"
  }
}
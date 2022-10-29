provider "aws" {
  region = "eu-central-1"
}

module "vpc_dev" {
  source              = "../modules/aws_network"
  env                 = "dev"
  vpc_cidr            = "10.100.0.0/16"
  public_subnet_cidrs = [
    "10.100.1.0/24",
    "10.100.2.0/24",
  ]
  private_subnet_cidrs = []
}

module "vpc_test" {
  source              = "../modules/aws_network"
  env                 = "test"
  vpc_cidr            = "10.10.0.0/16"
  public_subnet_cidrs = [
    "10.10.1.0/24",
    "10.10.2.0/24",
  ]
  private_subnet_cidrs = [
    "10.10.11.0/24",
    "10.10.22.0/24",
  ]
}

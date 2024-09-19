data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

data "aws_ami" "amazon_linux_kernel_5_10_hvm" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}

data "aws_ami" "amazon_linux_nat" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-*-x86_64-ebs"]
  }
}
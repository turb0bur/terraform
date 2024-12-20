data "aws_availability_zones" "available" {}

data "aws_ami" "amazon_linux_bastion" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
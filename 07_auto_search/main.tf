provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "latest_amazon_linux_2_ami" {
  owners = ["679593333241"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Amazon ECS Optimized Amazon Linux 2 *"]
  }
}

output "latest_amazon_linux_2_ami" {
  value = data.aws_ami.latest_amazon_linux_2_ami.id
}

resource "aws_instance" "web_server" {
  ami = data.aws_ami.latest_amazon_linux_2_ami.id
  instance_type = "t3.micro"
}
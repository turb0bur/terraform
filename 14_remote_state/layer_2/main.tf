provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    region = "us-east-1"
    bucket = "butko-terraform-learning-course"
    key    = "dev/servers/terraform.tfstate"
  }
}

resource "aws_security_group" "webserver_sg" {
  vpc_id = data.terraform_remote_state.network.outputs.main_vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network.outputs.main_vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "dev-web-server-sg"
    Owner = "Volodymyr Butko"
  }
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "webserver" {
  ami             = data.aws_ami.latest_amazon_linux.id
  instance_type   = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  subnet_id       = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  user_data       = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: <strong>$myip</strong></h2><p>Build by Terraform with Remote State</p>"  >  /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF
  tags            = {
    Name = "${var.env}-webserver"
  }
}
resource "aws_instance" "web_server_with_lifecycle" {
  #  ami             = "ami-05ff5eaef6149df49"
  ami             = "ami-08658d5197becde34"
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.web_server_security_group.name]
  user_data       = file("user_data.sh")
  tags            = {
    Name    = "Apache Web Server"
    Owner   = "Volodymyr Butko"
    Project = "Terraform Learning"
  }

  lifecycle {
    #    prevent_destroy = true
    #    ignore_changes = [ami]
    create_before_destroy = true
  }
}

resource "aws_eip" "web_server_elastic_ip" {
  instance = aws_instance.web_server_with_lifecycle.id
}

resource "aws_security_group" "web_server_security_group" {
  name        = "Web Server Security Group"
  description = "Security group for EC2 instance"

  ingress {
    description = "HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "EC2 SG"
  }
}
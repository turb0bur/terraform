resource "aws_instance" "my_web_server" {
  ami             = "ami-08658d5197becde34"
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.web_server_security_group.name]
  tags            = {
    Name    = "Apache Web Server"
    Owner   = "Volodymyr Butko"
  }

  depends_on = [aws_instance.my_db_server, aws_instance.my_application_server]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "my_application_server" {
  ami             = "ami-08658d5197becde34"
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.web_server_security_group.name]
  tags            = {
    Name    = "Java App Server"
    Owner   = "Volodymyr Butko"
  }

  depends_on = [aws_instance.my_db_server]
}

resource "aws_instance" "my_db_server" {
  ami             = "ami-08658d5197becde34"
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.web_server_security_group.name]
  tags            = {
    Name    = "MySQL DB Server"
    Owner   = "Volodymyr Butko"
  }
}

resource "aws_security_group" "web_server_security_group" {
  name        = "Web Server Security Group"
  description = "Security group for EC2 instance"

  dynamic "ingress" {
    for_each = [80, 443, 22]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2 Security Group"
  }
}
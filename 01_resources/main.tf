resource "aws_instance" "web_server" {
  ami             = "ami-05ff5eaef6149df49"
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.web_server_security_group.name]
  user_data       = templatefile("user_data.sh.tpl", {
    first_name = "Volodymyr"
    last_name  = "Butko"
    team_mates = ["Yura", "Volodia", "Oleks", "Liubko"]
  })
  tags = {
    Name    = "Apache Web Server"
    Owner   = "Volodymyr Butko"
    Project = "Terraform Learning"
  }
}

resource "aws_security_group" "web_server_security_group" {
  name        = "Web Server Security Group"
  description = "My first security group for EC2 instance"
  #  vpc_id      = aws_default_vpc.aws_default_vpc.id

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
  }

  tags = {
    Name = "EC2 SG"
  }
}

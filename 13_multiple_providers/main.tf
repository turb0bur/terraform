resource "aws_instance" "nova_server" {
  provider = aws.us-east-1
  ami = data.aws_ami.latest_amazon_linux_nova.id
  instance_type = "t3.micro"
}

resource "aws_instance" "london_server" {
  provider = aws.eu-west-2
  ami = data.aws_ami.latest_amazon_linux_london.id
  instance_type = "t3.micro"
}

resource "aws_instance" "frankfurt_server" {
  provider = aws.eu-central-1
  ami = data.aws_ami.latest_amazon_linux_frankfurt.id
  instance_type = "t3.micro"
}

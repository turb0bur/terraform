output "my_server_public_ip" {
  value = aws_eip.web_server_elastic_ip.public_ip
}
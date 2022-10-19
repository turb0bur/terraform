output "web_server_instance_id" {
  value = aws_instance.my_web_server.id
}

output "web_server_public_id" {
  value = aws_instance.my_web_server.public_ip
}

output "web_server_sg_id" {
  value = aws_security_group.web_server_security_group.id
}

output "web_server_sg_arn" {
  value = aws_security_group.web_server_security_group.arn
}

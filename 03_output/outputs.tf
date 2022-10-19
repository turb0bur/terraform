output "web_server_instance_id" {
  value = aws_instance.web_server_with_lifecycle.id
}

output "web_server_public_id" {
  value = aws_eip.web_server_elastic_ip.public_ip
}

output "web_server_sg_id" {
  value = aws_security_group.web_server_security_group.id
}

output "web_server_sg_arn" {
  value = aws_security_group.web_server_security_group.arn
}

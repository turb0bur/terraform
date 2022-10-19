output "network_details" {
  value = data.terraform_remote_state.network
}

output "webserver_sg_id" {
  value = aws_security_group.webserver_sg.id
}

output "webserver_public_ip" {
  value = aws_instance.webserver.public_ip
}
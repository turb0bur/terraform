output "latest_amazon_linux_2_ami" {
  value = data.aws_ami.latest_amazon_linux.id
}

output "web_load_balancer_url" {
  value = aws_elb.my_classic_lb.dns_name
}

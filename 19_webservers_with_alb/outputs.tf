output "my_load_balancer_url" {
  value = aws_lb.my_alb.dns_name
}
locals {
  my_azs = data.aws_availability_zones.available.names
  alb_bucket_logs_prefix = "my-alb"
}
variable "region" {
  description = "Default AWS region"
  type = string
  default = "eu-central-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type = string
  default = "t3.micro"
}

variable "allowed_ports" {
  description = "List of ports to open for server"
  type = list
  default = [80, 443, 22]
}

variable "enable_detailed_monitoring" {
  description = "Enable/disable monitoring for EC2 instance"
  type = bool
  default = false
}

variable "common_tags" {
  description = "Common tags are being used for different resources"
  type = map
  default = {
    Owner = "Volodymyr Butko"
    Project = "My 1st Terraform project"
#    Region = ${var.region}
    Environment = "dev"
  }
}
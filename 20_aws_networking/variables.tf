variable "region" {
  description = "The AWS region"
  type        = string
}

variable "vpc_settings" {
  type = object({
    name                 = string
    cidr                 = string
    enable_dns_support   = bool
    enable_dns_hostnames = bool
  })
  description = "The settings for the VPC"
}

variable "subnet_settings" {
  type = object({
    public = map(object({
      cidr                    = string
      map_public_ip_on_launch = bool
      name                    = string
    }))
    private = map(object({
      cidr = string
      name = string
    }))
  })
  description = "The settings for the subnets"
}

variable "igw_settings" {
  type = object({
    name = string
  })
  description = "The settings for the internet gateway"
  default = {
    name = "main-igw"
  }
}

variable "public_route_table_settings" {
  type = object({
    routes = map(object({
      cidr_block = string
    }))
    name = string
  })
  description = "The settings for the public route table"
  default = {
    routes = {
      internet = {
        cidr_block = "0.0.0.0/0"
      }
    }
    name = "public-route-table"
  }
}

variable "private_route_table_settings" {
  type = object({
    routes = map(object({
      cidr_block = string
    }))
    name = string
  })
  description = "The settings for the private route table"
  default = {
    routes = {
      internet = {
        cidr_block = "0.0.0.0/0"
      }
    }
    name = "private-route-table"
  }
}

variable "public_instances_config" {
  type = object({
    template_prefix_name = string
    instance_type        = string
    ami                  = string
    root_volume_name     = string
    ebs_volume = object({
      size                  = number
      type                  = string
      delete_on_termination = bool
    })
  })
  description = "The configuration for the public servers"
}

variable "public_asg_config" {
  type = object({
    name                      = string
    desired_capacity          = number
    max_size                  = number
    min_size                  = number
    launch_template_version   = string
    health_check_type         = string
    health_check_grace_period = number
    tags                      = map(string)
  })
  description = "The configuration for the public auto scaling group"
}

variable "private_instances_config" {
  type = object({
    template_prefix_name = string
    instance_type        = string
    ami                  = string
    root_volume_name     = string
    ebs_volume = object({
      size                  = number
      type                  = string
      delete_on_termination = bool
    })
  })
  description = "The configuration for the private servers"
}

variable "private_asg_config" {
  type = object({
    name                      = string
    desired_capacity          = number
    max_size                  = number
    min_size                  = number
    launch_template_version   = string
    health_check_type         = string
    health_check_grace_period = number
    tags                      = map(string)
  })
  description = "The configuration for the private auto scaling group"
}

variable "nat_instances_config" {
  type = object({
    template_prefix_name = string
    instance_type        = string
    ami                  = string
    root_volume_name     = string
    ebs_volume = object({
      size                  = number
      type                  = string
      delete_on_termination = bool
    })
  })
  description = "The configuration for the NAT instances"
}

variable "nat_asg_config" {
  type = object({
    name                      = string
    desired_capacity          = number
    max_size                  = number
    min_size                  = number
    launch_template_version   = string
    health_check_type         = string
    health_check_grace_period = number
    tags                      = map(string)
  })
  description = "The configuration for the NAT auto scaling group"
  default = {
    name                      = "nat-asg"
    desired_capacity          = 1
    max_size                  = 2
    min_size                  = 1
    launch_template_version   = "$Latest"
    health_check_type         = "EC2"
    health_check_grace_period = 300
    tags = {
      Name = "nat-asg-instance"
    }
  }
}


variable "nat_sg_settings" {
  description = "The settings for the NAT security group"
  default = {
    name = "nat-sg"
    ingress = {
      default = {
        protocol = "-1"
      }
    }
    egress = {
      default = {
        protocol   = "-1"
        cidr_block = "0.0.0.0/0"
      }
    }
  }
}

variable "public_sg_settings" {
  type = object({
    name = string
    ingress = map(object({
      from_port  = number
      to_port    = number
      protocol   = string
      cidr_block = string
    }))
    egress = map(object({
      protocol   = string
      cidr_block = string
    }))
  })
  description = "The settings for the public security group"
  default = {
    name = "public-sg"
    ingress = {
      http = {
        from_port  = 80
        to_port    = 80
        protocol   = "tcp"
        cidr_block = "0.0.0.0/0"
      }
    }
    egress = {
      default = {
        protocol   = "-1"
        cidr_block = "0.0.0.0/0"
      }
    }
  }
}

variable "private_sg_settings" {
  type = object({
    name = string
    ingress = map(object({
      from_port  = number
      to_port    = number
      protocol   = string
      cidr_block = string
    }))
    egress = map(object({
      protocol   = string
      cidr_block = string
    }))
  })
  description = "The settings for the private security group"
  default = {
    name = "private-sg"
    ingress = {
      icmp = {
        from_port  = -1
        to_port    = -1
        protocol   = "icmp"
        cidr_block = ""
      }
      https = {
        from_port  = 443
        to_port    = 443
        protocol   = "tcp"
        cidr_block = ""
      }
    }
    egress = {
      default = {
        protocol   = "-1"
        cidr_block = "0.0.0.0/0"
      }
    }
  }
}

variable "public_alb_config" {
  description = "The configuration for the public application load balancer"
  default = {
    name    = "public-alb"
    tg_name = "public-tg"
  }
}

variable "private_alb_config" {
  description = "The configuration for the private application load balancer"
  default = {
    name    = "private-alb"
    tg_name = "private-tg"
  }
}

variable "region" {
  description = "The AWS region"
  type        = string
}

variable "environment" {
  description = "The environment"
  type        = string
}

variable "vpc_settings" {
  description = "The common settings for the VPC"
  type = object({
    name                 = string
    cidr                 = string
    enable_dns_support   = bool
    enable_dns_hostnames = bool
  })
}

variable "subnet_settings" {
  description = "The settings for the subnets"
  type = object({
    public = map(object({
      map_public_ip_on_launch = bool
      name                    = string
      cidr                    = string
    }))
    private = map(object({
      name = string
      cidr = string
    }))
  })
}

variable "igw_settings" {
  description = "The settings for the internet gateway"
  type = object({
    name = string
  })
  default = {
    name = "main-igw"
  }
}

variable "public_route_table_settings" {
  description = "The settings for the public route table"
  type = object({
    routes = map(object({
      cidr_block = string
    }))
    name = string
  })
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
  description = "The settings for the private route table"
  type = object({
    routes = map(object({
      cidr_block = string
    }))
    name = string
  })
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
  description = "The common configuration for the public servers"
  type = object({
    instance_type        = string
    template_prefix_name = string
    root_volume_name     = string
    ebs_volume = object({
      size                  = number
      type                  = string
      delete_on_termination = bool
    })
  })
}

variable "public_frontend_asg_config" {
  description = "The common configuration for the public auto scaling group"
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
}

variable "private_instances_config" {
  description = "The configuration for the private servers"
  type = object({
    instance_type        = string
    template_prefix_name = string
    root_volume_name     = string
    ebs_volume = object({
      size                  = number
      type                  = string
      delete_on_termination = bool
    })
  })
}

variable "private_api_asg_config" {
  description = "The configuration for the private auto scaling group"
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
}

variable "nat_instances_config" {
  description = "The configuration for the NAT instances"
  type = object({
    instance_type        = string
    template_prefix_name = string
    root_volume_name     = string
    ebs_volume = object({
      size                  = number
      type                  = string
      delete_on_termination = bool
    })
  })
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
    max_size                  = 1
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
  type = object({
    name = string
  })
  default = {
    name = "nat-sg"
  }
}

variable "public_sg_settings" {
  description = "The settings for the public security group"
  type = object({
    name = string
  })
  default = {
    name = "public-sg"
  }
}

variable "private_sg_settings" {
  description = "The settings for the private security group"
  type = object({
    name = string
  })
  default = {
    name = "private-sg"
  }
}

variable "public_frontend_alb_config" {
  description = "The configuration for the public application load balancer"
  type = object({
    name    = string
    tg_name = string
  })
  default = {
    name    = "public-frontend-alb"
    tg_name = "public-frontend-tg"
  }
}

variable "private_api_alb_config" {
  description = "The configuration for the private application load balancer"
  type = object({
    name    = string
    tg_name = string
  })
  default = {
    name    = "private-api-alb"
    tg_name = "private-api-tg"
  }
}

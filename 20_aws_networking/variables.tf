variable "region" {
  description = "The AWS region"
  type        = string
}

variable "vpc_settings" {
  type = object({
    name                 = string
    dev_cidr             = string
    prod_cidr            = string
    enable_dns_support   = bool
    enable_dns_hostnames = bool
  })
  description = "The settings for the VPC"
  default = {
    name                 = "main-vpc"
    dev_cidr             = "10.0.0.0/16"
    prod_cidr            = "10.1.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
  }
}

variable "subnet_settings" {
  type = object({
    public = map(object({
      dev_cidr                = string
      prod_cidr               = string
      map_public_ip_on_launch = bool
      name                    = string
    }))
    private = map(object({
      dev_cidr  = string
      prod_cidr = string
      name      = string
    }))
  })
  description = "The settings for the subnets"
  default = {
    public = {
      subnet1 = {
        dev_cidr                = "10.0.1.0/24"
        prod_cidr               = "10.1.1.0/24"
        map_public_ip_on_launch = true
        name                    = "public-subnet-1"
      }
      subnet2 = {
        dev_cidr                = "10.0.2.0/24"
        prod_cidr               = "10.1.2.0/24"
        map_public_ip_on_launch = true
        name                    = "public-subnet-2"
      }
    }

    private = {
      subnet1 = {
        dev_cidr  = "10.0.10.0/24"
        prod_cidr = "10.1.10.0/24"
        name      = "private-subnet-1"
      }
      subnet2 = {
        dev_cidr  = "10.0.20.0/24"
        prod_cidr = "10.1.20.0/24"
        name      = "private-subnet-2"
      }
    }
  }
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

variable "ssh_keys_config" {
  type = object({
    name = string
    path = string
  })
  description = "The configuration for the SSH keys"
  default = {
    name = "deployer-key"
    path = "~/.ssh/deployer-key.pub"
  }
}

variable "public_instances_config" {
  type = object({
    template_prefix_name = string
    dev_instance_type    = string
    prod_instance_type   = string
    ami                  = string
    root_volume_name     = string
    ebs_volume = object({
      dev_size              = number
      prod_size             = number
      type                  = string
      delete_on_termination = bool
    })
  })
  description = "The configuration for the public servers"
  default = {
    template_prefix_name = "public-instance-"
    dev_instance_type    = "t2.micro"
    prod_instance_type   = "t2.small"
    ami                  = "ami-0de02246788e4a354"
    root_volume_name     = "/dev/xvda"
    ebs_volume = {
      dev_size              = 8
      prod_size             = 20
      type                  = "gp3"
      delete_on_termination = true
    }
  }
}

variable "public_asg_config" {
  type = object({
    name                      = string
    dev_desired_capacity      = number
    prod_desired_capacity     = number
    dev_max_size              = number
    prod_max_size             = number
    min_size                  = number
    launch_template_version   = string
    health_check_type         = string
    health_check_grace_period = number
    tags                      = map(string)
  })
  description = "The configuration for the public auto scaling group"
  default = {
    name                      = "public-asg"
    dev_desired_capacity      = 2
    prod_desired_capacity     = 2
    dev_max_size              = 2
    prod_max_size             = 4
    min_size                  = 1
    launch_template_version   = "$Latest"
    health_check_type         = "EC2"
    health_check_grace_period = 300
    tags = {
      Name = "public-asg-instance"
    }
  }
}

variable "private_instances_config" {
  type = object({
    template_prefix_name = string
    dev_instance_type    = string
    prod_instance_type   = string
    ami                  = string
    root_volume_name     = string
    ebs_volume = object({
      dev_size              = number
      prod_size             = number
      type                  = string
      delete_on_termination = bool
    })
  })
  description = "The configuration for the private servers"
  default = {
    template_prefix_name = "private-instance-"
    dev_instance_type    = "t2.micro"
    prod_instance_type   = "t2.small"
    ami                  = "ami-0de02246788e4a354"
    root_volume_name     = "/dev/xvda"
    ebs_volume = {
      dev_size              = 8
      prod_size             = 20
      type                  = "gp3"
      delete_on_termination = true
    }
  }
}

variable "private_asg_config" {
  type = object({
    name                      = string
    dev_desired_capacity      = number
    prod_desired_capacity     = number
    dev_max_size              = number
    prod_max_size             = number
    min_size                  = number
    launch_template_version   = string
    health_check_type         = string
    health_check_grace_period = number
    tags                      = map(string)
  })
  description = "The configuration for the private auto scaling group"
  default = {
    name                      = "private-asg"
    dev_desired_capacity      = 2
    prod_desired_capacity     = 2
    dev_max_size              = 2
    prod_max_size             = 4
    min_size                  = 1
    launch_template_version   = "$Latest"
    health_check_type         = "EC2"
    health_check_grace_period = 300
    tags = {
      Name = "private-asg-instance"
    }
  }
}

variable "nat_instances_config" {
  type = object({
    template_prefix_name = string
    dev_instance_type    = string
    prod_instance_type   = string
    ami                  = string
    root_volume_name     = string
    ebs_volume = object({
      size                  = number
      type                  = string
      delete_on_termination = bool
    })
  })
  description = "The configuration for the NAT instances"
  default = {
    template_prefix_name = "nat-instance-"
    dev_instance_type    = "t2.micro"
    prod_instance_type   = "t2.small"
    ami                  = "ami-0c3b2f7a7308f788a"
    root_volume_name     = "/dev/xvda"
    ebs_volume = {
      size                  = 8
      type                  = "gp3"
      delete_on_termination = true
    }
  }
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
      ssh = {
        from_port  = 22
        to_port    = 22
        protocol   = "tcp"
        cidr_block = ""
      }
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
      ssh = {
        from_port  = 22
        to_port    = 22
        protocol   = "tcp"
        cidr_block = ""
      }
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

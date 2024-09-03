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

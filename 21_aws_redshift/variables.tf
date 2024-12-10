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
    data = map(object({
      map_public_ip_on_launch = bool
      name                    = string
      cidr                    = string
    }))
  })
}

variable "bastion_sg_settings" {
  description = "The security group settings for the bastion host"
  type = object({
    name        = string
    description = string
  })
  default = {
    name        = "bastion-sg"
    description = "Bastion Host security group"
  }
}

variable "bastion_host_settings" {
  description = "The settings for the bastion host"
  type = object({
    name          = string
    instance_type = string
  })
  default = {
    name          = "bastion-host"
    instance_type = "t3.micro"
  }
}

variable "redshift_sg_settings" {
  description = "The security group settings for the Redshift cluster"
  type = object({
    name        = string
    description = string
  })
  default = {
    name        = "redshift-sg"
    description = "Redshift security group"
  }
}

variable "redshift_cluster_settings" {
  description = "The settings for the Redshift cluster"
  type = object({
    subnet_group_name = string
    name              = string
    type              = string
    node_type         = string
    node_count        = number
  })
}

variable "redshift_db_name" {
  description = "The database name"
  type        = string
  default     = "dbt_project"
}

variable "redshift_db_user" {
  description = "The database username"
  type        = string
  default     = "data_engineer"
}
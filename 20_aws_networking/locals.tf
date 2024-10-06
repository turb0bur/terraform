locals {
  resource_name = join("-", [var.region, var.environment, "%s"])

  public_subnet_names = { for k, v in var.subnet_settings.public : k => format(local.resource_name, v.name) }
  public_subnet_cidrs = { for k, v in var.subnet_settings.public : k => v.cidr }

  app_subnet_names = { for k, v in var.subnet_settings.app : k => format(local.resource_name, v.name) }
  app_subnet_cidrs = { for k, v in var.subnet_settings.app : k => v.cidr }

  db_subnet_names = { for k, v in var.subnet_settings.db : k => format(local.resource_name, v.name) }
  db_subnet_cidrs = { for k, v in var.subnet_settings.db : k => v.cidr }

  petclinic_asg_ec2_tags = merge({ Environment = var.environment }, var.petclinic_asg_config.tags)
  nat_asg_ec2_tags       = merge({ Environment = var.environment }, var.nat_asg_config.tags)

  ecr_repository_uri = format("%s.dkr.ecr.eu-central-1.amazonaws.com/%s", data.aws_caller_identity.current.account_id, var.ecr_repository)
  petclinic_image    = format("%s:%s", local.ecr_repository_uri, var.petclinic_image_tag)
}
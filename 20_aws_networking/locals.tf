locals {
  resource_name = join("-", [var.region, var.environment, "%s"])

  public_subnet_names = { for k, v in var.subnet_settings.public : k => format(local.resource_name, v.name) }
  public_subnet_cidrs = { for k, v in var.subnet_settings.public : k => v.cidr }

  private_subnet_names = { for k, v in var.subnet_settings.private : k => format(local.resource_name, v.name) }
  private_subnet_cidrs = { for k, v in var.subnet_settings.private : k => v.cidr }

  public_asg_ec2_tags  = merge({ Environment = var.environment }, var.public_asg_config.tags)
  private_asg_ec2_tags = merge({ Environment = var.environment }, var.private_asg_config.tags)
  nat_asg_ec2_tags     = merge({ Environment = var.environment }, var.nat_asg_config.tags)
}
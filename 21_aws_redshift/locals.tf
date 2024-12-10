locals {
  resource_name = join("-", [var.region, var.environment, "%s"])

  public_subnet_names = { for k, v in var.subnet_settings.public : k => format(local.resource_name, v.name) }
  public_subnet_cidrs = { for k, v in var.subnet_settings.public : k => v.cidr }

  data_subnet_names = { for k, v in var.subnet_settings.data : k => format(local.resource_name, v.name) }
  data_subnet_cidrs = { for k, v in var.subnet_settings.data : k => v.cidr }

  param_store_prefix = format("%s/redshift", var.environment)
}
locals {
  vpc_name = join("-", [terraform.workspace, var.vpc_settings.name])
  vpc_cidr = var.vpc_settings["${terraform.workspace}_cidr"]

  public_subnet_names = { for k, v in var.subnet_settings.public : k => join("-", [terraform.workspace, v.name]) }
  public_subnet_cidrs = { for k, v in var.subnet_settings.public : k => v["${terraform.workspace}_cidr"] }

  private_subnet_names = { for k, v in var.subnet_settings.private : k => join("-", [terraform.workspace, v.name]) }
  private_subnet_cidrs = { for k, v in var.subnet_settings.private : k => v["${terraform.workspace}_cidr"] }

  igw_name        = join("-", [terraform.workspace, var.igw_settings.name])
  public_rt_name  = join("-", [terraform.workspace, var.public_route_table_settings.name])
  private_rt_name = join("-", [terraform.workspace, var.private_route_table_settings.name])
}
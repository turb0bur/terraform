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

  public_instance_prefix_name = join("-", [terraform.workspace, var.public_instances_config.template_prefix_name])
  public_instance_type        = var.public_instances_config["${terraform.workspace}_instance_type"]
  public_instance_ebs_size    = var.public_instances_config.ebs_volume["${terraform.workspace}_size"]

  public_asg_name             = join("-", [terraform.workspace, var.public_asg_config.name])
  public_asg_desired_capacity = var.public_asg_config["${terraform.workspace}_desired_capacity"]
  public_asg_max_size         = var.public_asg_config["${terraform.workspace}_max_size"]
  public_asg_ec2_tags         = merge({ Environment = terraform.workspace }, var.public_asg_config.tags)

  private_instance_prefix_name = join("-", [terraform.workspace, var.private_instances_config.template_prefix_name])
  private_instance_type        = var.private_instances_config["${terraform.workspace}_instance_type"]
  private_instance_ebs_size    = var.private_instances_config.ebs_volume["${terraform.workspace}_size"]

  private_asg_name             = join("-", [terraform.workspace, var.private_asg_config.name])
  private_asg_desired_capacity = var.private_asg_config["${terraform.workspace}_desired_capacity"]
  private_asg_max_size         = var.private_asg_config["${terraform.workspace}_max_size"]
  private_asg_ec2_tags         = merge({ Environment = terraform.workspace }, var.private_asg_config.tags)

  nat_instance_prefix_name = join("-", [terraform.workspace, var.nat_instances_config.template_prefix_name])
  nat_instance_type        = var.nat_instances_config["${terraform.workspace}_instance_type"]
  nat_asg_name             = join("-", [terraform.workspace, var.nat_asg_config.name])
  nat_asg_tags             = merge({ Environment = terraform.workspace }, var.nat_asg_config.tags)

  nat_sg_name     = join("-", [terraform.workspace, var.nat_sg_settings.name])
  public_sg_name  = join("-", [terraform.workspace, var.public_sg_settings.name])
  private_sg_name = join("-", [terraform.workspace, var.private_sg_settings.name])
}
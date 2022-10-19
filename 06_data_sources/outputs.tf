output "data_aws_available_sg" {
  value = data.aws_security_group.available_sg.vpc_id
}

output "data_aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "data_aws_region_name" {
  value = data.aws_region.current.name
}

output "data_aws_region_description" {
  value = data.aws_region.current.description
}

output "data_aws_vpcs_list" {
  value = data.aws_vpcs.my_vpcs
}

output "data_aws_vpc_default" {
  value = data.aws_vpc.default.id
}

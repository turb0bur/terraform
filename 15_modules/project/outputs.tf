output "dev_public_subnet_ids" {
  value = module.vpc_dev.public_subnet_ids
}

output "dev_private_subnet_ids" {
  value = module.vpc_dev.private_subnet_ids
}

output "test_public_subnet_ids" {
  value = module.vpc_test.public_subnet_ids
}

output "test_private_subnet_ids" {
  value = module.vpc_test.private_subnet_ids
}
provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "butko-terraform-learning-course"
    key    = "dev/global_vars/terraform.tfstate"
    region = "us-east-1"
  }
}

output "company_name" {
  value = "Turb0bur"
}

output "tags" {
  value = {
    Project = "Terraform"
    Country = "Ukraine"
    Owner   = "Volodymyr Butko"
  }
}
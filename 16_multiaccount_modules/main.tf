provider "aws" {
  region = "eu-central-1"
}

provider "aws" {
  alias  = "test"
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::278336501300:role/AWSAccountRoleForTerraformLearning"
  }
}

provider "aws" {
  alias  = "prod"
  region = "eu-west-2"
  assume_role {
    role_arn = "arn:aws:iam::425252124754:role/AWSAccountRoleForTerraformLearning"
  }
}

module "web_servers" {
  source    = "./modules/aws_web_servers"
  providers = {
    aws.dev = aws
    aws.test  = aws.test
    aws.prod = aws.prod
  }
  instance_type = "t3.micro"
}
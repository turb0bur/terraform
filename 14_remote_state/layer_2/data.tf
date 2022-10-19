data "terraform_remote_state" "network" {
  backend = "s3"
  config  = {
    region = "us-east-1"
    bucket = "butko-terraform-learning-course"
    key    = "dev/network/terraform.tfstate"
  }
}

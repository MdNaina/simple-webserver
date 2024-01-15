terraform {
  backend "s3" {
    bucket = "2k-terraform-state-001"
    key = "web_server/terraform.tfstate"
    encrypt = true
    dynamodb_table = "tf-backend"
    

    profile = "terraform"
    region = "eu-north-1"
  }
}

provider "aws" {
  profile = var.aws_profile
  region = var.aws_region
}

data "template_file" "user_data" {
  template = file("${path.module}/../configuration/user_data.yml")
  vars = { "USER": var.USER, "SSH_PUBLIC_KEY": var.SSH_PUBLIC_KEY }
}

module "web_server" {
  source = "./modules/web_server"
  aws_profile = var.aws_profile
  aws_region = var.aws_region
  instance_type = var.instance_type
  user_data = data.template_file.user_data.rendered
  SSH_PUBLIC_KEY = var.SSH_PUBLIC_KEY
  USER = var.USER
}

output "public_ip" {
  value = module.web_server.public_ip
}

output "user_and_key" {
  value = module.web_server.user_and_key
}
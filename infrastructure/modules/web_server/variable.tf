variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "user_data" {
  description = "cloud init script"
}

variable "aws_profile" {
  description = "AWS profile"
}

variable "USER" {
  description = "EC2 user"
  default = "dev"
}

variable "SSH_PUBLIC_KEY" {
  description = "authorized ssh public key"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default = "t3.micro"
}

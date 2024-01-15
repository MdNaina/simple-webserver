variable "aws_region" {
  description = "AWS region"
  type        = string
  default = "eu-north-1"
}

variable "aws_profile" {
  description = "AWS profile"
  default = "default"
}

variable "USER" {
  description = "EC2 user"
}

variable "SSH_PUBLIC_KEY" {
  description = "authorized ssh public key"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

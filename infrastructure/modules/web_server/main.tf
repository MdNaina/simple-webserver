provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

locals {
  ingress = [
    { port = "22", description = "SSH port"},
    { port = "80", description = "HTTP port"},
    { port = "443", description = "HTTPS port"},
  ]
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
      name = "name"
      values = [ "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*" ]
    }

    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }

    owners = [ "099720109477" ]
  
}

resource "aws_security_group" "sg" {
  name = "simple_security_group"
  dynamic "ingress" {
    for_each = local.ingress
    content {
      from_port = ingress.value.port
      to_port = ingress.value.port
      description = ingress.value.description
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "webserver" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  vpc_security_group_ids = [ aws_security_group.sg.id ]
  user_data = var.user_data
  provisioner "local-exec" {
    command = <<EOF
    echo "[webserver]" > ../inventory.ini
    echo "${self.public_ip} ansible_user=${var.USER} ansible_ssh_private_key_file=ssh_keys/my_key" >> ../inventory.ini
    EOF
  }
}

output "public_ip" {
  value = aws_instance.webserver.public_ip
}

output "user_and_key" {
  value = "${var.USER} \n${var.SSH_PUBLIC_KEY}"
}
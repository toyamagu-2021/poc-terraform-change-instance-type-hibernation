terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_instance" "this" {
  ami           = "ami-0f9816f78187c68fb"
  instance_type = var.instance_type
  hibernation   = true

  root_block_device {
    volume_size           = "20"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = false
  }

  tags = {
    Name = "toyamagu"
  }
  volume_tags = {
    Name = "toyamagu"
    uid  = "this-is-unique-id-hogehoge-fugafuga"
  }
}

output "ec2_instance_id" {
  value = aws_instance.this.id
}

output "ec2_instance_volume_id" {
  value = aws_instance.this.root_block_device.0.volume_id
}

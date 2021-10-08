##### Packer settings #####

packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

##### Variables blocks #####

variable "aws_access_key" {
  type        = string
  description = "AWS access key used to deploy resources"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret access key used to deploy resources"
}

variable "aws_region" {
  type        = string
  description = "AWS region where the resources will be created"
}

variable "aws_ec2_ami" {
  type        = string
  description = "AWS AMI used in EC2 instance"
  default     = "ami-02e136e904f3da870"
}

variable "aws_ami_name_prefix" {
  type        = string
  description = "Name of the AMI to be built"
  default     = "flugel-app-ami-"
}

variable "aws_ec2_class" {
  type        = string
  description = "AWS EC2 instance class type"
  default     = "t2.micro"
}

variable "datetime_format" {
  type        = string
  description = "The datetime format to converts a timestamp"
  default     = "MMDDYYYY-hhmmss"
}

##### Source block #####

source "amazon-ebs" "ubuntu" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  ami_name      = "${var.aws_ami_name_prefix}${formatdate(var.datetime_format, timestamp())}"
  instance_type = var.aws_ec2_class
  region        = var.aws_region
  source_ami    = var.aws_ec2_ami

  ssh_username = "ec2-user"
}

##### Build block #####

build {
  name    = "flugel-app"
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "mkdir fastapi"
    ]
  }

  provisioner "file" {
    source      = "../../requirements.txt"
    destination = "./fastapi/"
  }

  provisioner "file" {
    source      = "../../.env"
    destination = "./fastapi/"
  }

  provisioner "file" {
    source      = "../../app"
    destination = "./fastapi"
  }

  provisioner "file" {
    source      = "../../flugel-app.service"
    destination = "/tmp/"
  }

  provisioner "shell" {
    inline = [
      "pip3 install --no-cache-dir --upgrade -r ./fastapi/requirements.txt",
      "sudo mv /tmp/flugel-app.service /etc/systemd/system/"
    ]
  }
}
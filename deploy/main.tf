##### Terraform settings #####

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

##### Provider block #####

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

##### Data block #####

data "http" "my_public_ip" {
  url = "http://ipv4.icanhazip.com"
  request_headers = {
    Accept = "application/json"
  }
}

data "aws_ami" "flugel_app_ami" {
  owners      = ["self"]
  most_recent = true

  filter {
    name   = "name"
    values = ["flugel-app-ami-*"]
  }
}

##### Resources blocks #####

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "flugel_app_key" {
  key_name   = "flugel-app-key"
  public_key = tls_private_key.ec2_key.public_key_openssh

  tags = var.aws_resources_tags

  provisioner "local-exec" {
    command = "echo '${tls_private_key.ec2_key.private_key_pem}' > ./flugel-app-key.pem"
  }
}

resource "aws_instance" "flugel_app" {
  ami                    = data.aws_ami.flugel_app_ami.image_id
  instance_type          = var.aws_ec2_class
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.flugel_sg.id]
  key_name               = aws_key_pair.flugel_app_key.key_name

  associate_public_ip_address = false

  user_data = <<EOF
  #!/bin/bash
  sudo systemctl daemon-reload
  sudo systemctl enable flugel-app
  sudo systemctl start flugel-app
  EOF

  tags = var.aws_resources_tags
}

resource "aws_eip" "flugel_app_eip" {
  instance = aws_instance.flugel_app.id
}

resource "aws_security_group" "flugel_sg" {
  name = "flugel-security-group"

  vpc_id = var.default_vpc_id

  # allow ssh inbound connection
  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.tcp_protocol
    cidr_blocks = ["${chomp(data.http.my_public_ip.body)}/32"]
  }

  # allow fastapi app inbound connection
  ingress {
    from_port   = var.fastapi_port
    to_port     = var.fastapi_port
    protocol    = var.tcp_protocol
    cidr_blocks = [var.all_ips_cidr]
  }

  # allow http inbound connection
  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = var.tcp_protocol
    cidr_blocks = [var.all_ips_cidr]
  }

  # allow http outbound connection
  egress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = var.tcp_protocol
    cidr_blocks = [var.all_ips_cidr]
  }

  # allow all tcp outbound connection (for boto3 requests)
  egress {
    from_port   = var.tcp_start_port
    to_port     = var.tcp_end_port
    protocol    = var.tcp_protocol
    cidr_blocks = [var.all_ips_cidr]
  }

  tags = var.aws_resources_tags
}

resource "aws_s3_bucket" "flugel_bucket" {
  bucket = "${var.bucket_name_prefix}${formatdate(var.datetime_format, timestamp())}"
  acl    = "private"

  tags = var.aws_resources_tags
}
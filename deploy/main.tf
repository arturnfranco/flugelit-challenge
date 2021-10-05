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
  profile = var.aws_profile
  region  = var.aws_region
}

##### Resources blocks #####

resource "aws_instance" "flugel_server" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
  tags          = var.resources_tags
}

resource "aws_s3_bucket" "flugel_bucket" {
  bucket = "${var.bucket_name_prefix}${formatdate(var.datetime_format, timestamp())}"
  acl    = "private"
  tags   = var.resources_tags
}
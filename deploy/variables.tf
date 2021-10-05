variable "aws_profile" {
  type        = string
  description = "AWS profile (credentials) to use to deploy resources"
  default     = "default"
}

variable "aws_region" {
  type        = string
  description = "AWS region where the resources will be created"
}

variable "bucket_name_prefix" {
  type        = string
  description = "The prefix of the S3 bucket name"
  default     = "flugel-it-bucket-"
}

variable "datetime_format" {
  type        = string
  description = "The datetime format to converts a timestamp"
  default     = "MMDDYYYY-hhmmss"
}

variable "resources_tags" {
  type        = map(string)
  description = "Value of the Name/Owner tags for the AWS resources (EC2 instance and S3 bucket)"
  default = {
    Name  = "Flugel"
    Owner = "InfraTeam"
  }
}
##### Credentials variables #####

variable "aws_access_key" {
  type        = string
  description = "AWS public credential"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS private credential"
}

##### AWS general variables #####

variable "aws_region" {
  type        = string
  description = "AWS region where the resources will be created"
  default     = "us-east-1"
}

variable "aws_resources_tags" {
  type        = map(string)
  description = "Map with the tags for the AWS resources (EC2 instance and S3 bucket)"
  default = {
    Name  = "Flugel"
    Owner = "InfraTeam"
  }
}

##### AWS EC2 variables #####

variable "aws_ec2_class" {
  type        = string
  description = "AWS EC2 instance class type"
  default     = "t2.micro"
}

##### AWS S3 bucket variables #####

variable "bucket_name_prefix" {
  type        = string
  description = "The prefix of the S3 bucket name"
  default     = "flugel-it-bucket-"
}

##### VPC resources variables #####

variable "default_vpc_id" {
  type        = string
  description = "Default VPC id"
  default     = "vpc-03c2904d9ca8ebaaf"
}

variable "subnet_id" {
  type        = string
  description = "ID of a subnet of AWS default VPC"
  default     = "subnet-0bc26812d38636800"
}

variable "tcp_protocol" {
  type        = string
  description = "TCP protocol"
  default     = "tcp"
}

variable "all_ips_cidr" {
  type        = string
  description = "CIDR block that represents all IPv4 addresses"
  default     = "0.0.0.0/0"
}

variable "tcp_start_port" {
  type        = number
  description = "First port of TCP port range"
  default     = 0
}

variable "tcp_end_port" {
  type        = number
  description = "Last port of TCP port range"
  default     = 65535
}

variable "ssh_port" {
  type        = number
  description = "SSH port"
  default     = 22
}

variable "http_port" {
  type        = number
  description = "HTTP port"
  default     = 80
}

variable "fastapi_port" {
  type        = number
  description = "The port on which the app will run"
  default     = 8000
}

##### Util variables #####

variable "datetime_format" {
  type        = string
  description = "The datetime format to converts a timestamp"
  default     = "MMDDYYYY-hhmmss"
}
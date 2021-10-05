output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.flugel_server.id
}

output "ec2_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.flugel_server.public_ip
}

output "ec2_instance_tags" {
  description = "Tags of the EC2 instance"
  value       = aws_instance.flugel_server.tags_all
}

output "s3_bucket_tags" {
  description = "Tags of the S3 bucket"
  value       = aws_s3_bucket.flugel_bucket.tags_all
}
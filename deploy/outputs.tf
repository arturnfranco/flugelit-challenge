output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.flugel_app.id
}

output "ec2_instance_public_ip" {
  description = "Public Elastic IP address of the EC2 instance"
  value       = aws_eip.flugel_app_eip.public_ip
}

output "ec2_instance_tags" {
  description = "Tags of the EC2 instance"
  value       = aws_instance.flugel_app.tags_all
}

output "s3_bucket_tags" {
  description = "Tags of the S3 bucket"
  value       = aws_s3_bucket.flugel_bucket.tags_all
}
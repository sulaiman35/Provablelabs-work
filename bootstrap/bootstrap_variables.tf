variable "aws_region" {
  description = "The AWS region where the backend resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "The name for the S3 bucket to store Terraform state"
  type        = string
  default = "206055865483-provable-labs-10aug2025"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnets" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet IDs"
  type        = list(string)
}



variable "frontend_bucket_name" {
  description = "Frontend S3 bucket name"
  type        = string
}

variable "codeconnection_arn" {
  description = "CodeConnection ARN for GitHub"
  type        = string
}

variable "frontend_bucket_arn" {
  description = "Frontend S3 bucket ARN"
  type        = string
}

variable "asg_name" {
  description = "Auto Scaling Group name"
  type        = string
}


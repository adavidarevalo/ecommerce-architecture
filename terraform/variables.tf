variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "ecommerce"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}
//User Data
variable "mongodb_uri" {
  description = "MongoDB connection string"
  type        = string
}

variable "port" {
  description = "Express app port"
  type        = string
  default     = "3000"
}

variable "jwt_secret" {
  description = "JWT secret key"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name for website"
  type        = string
  default     = "frontend.davidarevalo.info"
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for ALB"
  type        = string
  default     = "arn:aws:acm:us-east-1:779846783544:certificate/4a18358f-19fa-43fd-ab8f-c39e5a4da178"
}

variable "backend_domain" {
  description = "Backend domain name"
  type        = string
  default     = "backend.davidarevalo.info"
}

variable "frontend_domain" {
  description = "Frontend domain name"
  type        = string
  default     = "frontend.davidarevalo.info"
}
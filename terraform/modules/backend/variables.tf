variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "mongodb_uri" {
  description = "MongoDB connection string"
  type        = string
}

variable "port" {
  description = "Express app port"
  type        = string
}

variable "jwt_secret" {
  description = "JWT secret key"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for ALB"
  type        = string
}

variable "backend_domain" {
  description = "Backend domain name"
  type        = string
}
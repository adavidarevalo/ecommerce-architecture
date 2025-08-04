output "vpc_id" {
  description = "VPC ID"
  value       = module.backend.vpc_id
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.backend.alb_dns_name
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.backend.public_subnets
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.backend.private_subnets
}

output "bucket_name" {
  description = "S3 bucket name"
  value       = module.frontend.bucket_name
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.frontend.cloudfront_domain_name
}

output "backend_domain" {
  description = "Backend domain name"
  value       = var.backend_domain
}

output "frontend_domain" {
  description = "Frontend domain name"
  value       = var.frontend_domain
}
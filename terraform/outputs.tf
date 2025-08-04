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
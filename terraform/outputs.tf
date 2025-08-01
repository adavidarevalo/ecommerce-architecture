output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}



output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.igw_id
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.vpc.natgw_ids
}

output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "app_security_group_id" {
  description = "The ID of the application security group"
  value       = aws_security_group.app.id
}

output "launch_template_id" {
  description = "The ID of the launch template"
  value       = module.asg.launch_template_id
}

output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = module.asg.autoscaling_group_name
}

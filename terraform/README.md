# AWS VPC Terraform Configuration

This Terraform configuration creates a complete AWS VPC infrastructure for an e-commerce application using the official [AWS VPC module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest).

## Architecture Overview

The configuration creates:

- **VPC** with CIDR block 10.0.0.0/16
- **Public Subnets** (2) - For Application Load Balancer and NAT Gateway
- **Private Subnets** (2) - For application servers
- **Internet Gateway** - For public internet access
- **NAT Gateway** (per AZ) - For private subnet internet access
- **Security Groups** - For ALB, application, and database layers

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- AWS provider ~> 5.0

## Usage

1. **Initialize Terraform:**

   ```bash
   terraform init
   ```

2. **Review the plan:**

   ```bash
   terraform plan
   ```

3. **Apply the configuration:**

   ```bash
   terraform apply
   ```

4. **Customize configuration (optional):**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

## Configuration

### Variables

- `aws_region`: AWS region (default: us-east-1)
- `project_name`: Project name (default: ecommerce)
- `environment`: Environment name (default: dev)
- `vpc_cidr`: VPC CIDR block (default: 10.0.0.0/16)
- `availability_zones`: List of availability zones
- `public_subnets`: CIDR blocks for public subnets
- `private_subnets`: CIDR blocks for private subnets
- `database_subnets`: CIDR blocks for database subnets

### Outputs

- `vpc_id`: VPC ID
- `public_subnet_ids`: List of public subnet IDs
- `private_subnet_ids`: List of private subnet IDs
- `internet_gateway_id`: Internet Gateway ID
- `nat_gateway_ids`: List of NAT Gateway IDs
- `alb_security_group_id`: ALB Security Group ID
- `app_security_group_id`: Application Security Group ID
- `database_security_group_id`: Database Security Group ID

## Security Groups

### ALB Security Group

- **Ingress**: HTTP (80), HTTPS (443) from anywhere
- **Egress**: All traffic to anywhere

### Application Security Group

- **Ingress**: HTTP (80) from ALB security group
- **Egress**: All traffic to anywhere

### Database Security Group

- **Ingress**: MySQL (3306) from application security group

## VPC Module Features

This configuration uses the official AWS VPC module which provides:

- ✅ **Multi-AZ Support**: Automatically creates resources across multiple availability zones
- ✅ **NAT Gateway per AZ**: One NAT Gateway per availability zone for high availability
- ✅ **DNS Support**: Enables DNS hostnames and DNS support
- ✅ **Proper Tagging**: Consistent tagging across all resources
- ✅ **Route Tables**: Automatic route table creation and association
- ✅ **Internet Gateway**: Automatic Internet Gateway creation and attachment
- ✅ **Subnet Configuration**: Public and private subnets with proper routing

## Best Practices Implemented

- ✅ Uses verified public module from Terraform Registry
- ✅ Pinned module version for consistency
- ✅ Pinned AWS provider version
- ✅ Proper tagging strategy
- ✅ Security groups with least privilege
- ✅ Multi-AZ deployment
- ✅ Separate subnet tiers (public, private, database)
- ✅ NAT Gateway for private subnet internet access
- ✅ DNS support enabled
- ✅ Proper resource naming conventions

## Cost Considerations

- NAT Gateway incurs hourly charges (~$0.045/hour per AZ)
- EIP for NAT Gateway is free when attached to NAT Gateway
- Consider using `single_nat_gateway = true` for dev/test environments to reduce costs

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Warning**: This will delete all created resources including the VPC and all subnets.

## Module Reference

This configuration uses the [terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) module version ~> 5.0.

For more information about the module's features and configuration options, visit the [module documentation](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest).

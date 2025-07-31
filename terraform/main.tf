provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

# VPC Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  # NAT Gateway
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  # DNS
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Tags
  public_subnet_tags = {
    Type = "Public"
  }

  private_subnet_tags = {
    Type = "Private"
  }



  tags = local.common_tags
}

# --- Application Load Balancer (ALB) in Private Subnets ---
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name                       = "${var.project_name}-alb"
  vpc_id                     = module.vpc.vpc_id
  subnets                    = module.vpc.private_subnets
  internal                   = true
  enable_deletion_protection = false

  security_groups = [aws_security_group.alb.id]

  target_groups = [
    {
      name_prefix      = "app"
      backend_protocol = "HTTP"
      backend_port     = 3000
      target_type      = "instance"
      health_check = {
        enabled             = true
        healthy_threshold   = 2
        unhealthy_threshold = 2
        interval            = 30
        matcher             = "200-399"
        path                = "/"
        port                = "3000"
        protocol            = "HTTP"
        timeout             = 5
      }
    }
  ]

  tags = local.common_tags
}

# --- Security Groups ---
resource "aws_security_group" "alb" {
  name_prefix = "${var.project_name}-alb-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-alb-sg" })
}

resource "aws_security_group" "app" {
  name_prefix = "${var.project_name}-app-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-app-sg" })
}

# --- Data source for Ubuntu AMI ---
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# --- Auto Scaling Group (ASG) ---
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 7.0"

  name                = "${var.project_name}-asg"
  vpc_zone_identifier = module.vpc.private_subnets
  min_size            = 1
  max_size            = 2
  desired_capacity    = 1

  # Launch Template Configuration
  create_launch_template = true
  launch_template_name   = "${var.project_name}-app"

  image_id        = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.app.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y curl
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs
    npm install -g pm2
    mkdir -p /opt/app
    cat <<EON > /opt/app/index.js
    const express = require('express');
    const app = express();
    app.get('/', (req, res) => res.send('Hello from Express behind ALB!'));
    app.listen(3000, () => console.log('App running on port 3000'));
    EON
    cd /opt/app
    npm init -y
    npm install express
    pm2 start index.js
    pm2 startup
    pm2 save
  EOF
  )

  target_group_arns = [module.alb.target_group_arns[0]]

  tags = [
    {
      key                 = "Name"
      value               = "${var.project_name}-asg"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = var.project_name
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = var.environment
      propagate_at_launch = true
    }
  ]
}

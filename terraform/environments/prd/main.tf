module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "squid-vpc"
  cidr = var.vpc_cidr

  azs             = ["${var.aws_region}a"]
  public_subnets  = [cidrsubnet(var.vpc_cidr, 8, 1)]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Environment = var.environment
  }
}

module "squid_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "squid-sg"
  description = "Security group for Squid proxy"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 3128
      to_port     = 3128
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "squid" {
  source = "../../modules/squid"

  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.public_subnets[0]
  security_group_id = module.squid_sg.security_group_id
  environment       = var.environment
  container_image   = var.container_image
  aws_region        = var.aws_region
}
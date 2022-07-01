terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.66.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"  # California
}

#====================================

module "network" {
  source = "./modules/network"

  availability_zones = var.availability_zones
  cidr_block         = var.cidr_block
}

#====================================

module "security" {
  source = "./modules/security"
  # references to the child modules are made starting with the network module
  # 
  vpc_id         = module.network.vpc_id # which is configured as an output on the networking module. See outputs.tf
  workstation_ip = var.workstation_ip

  depends_on = [
    # security module has a dependency configured on the networking module since it needs and references the VPC ID
    # depends on this: vpc_id         = module.network.vpc_id
    module.network
  ]
}

#====================================

module "bastion" {
  source = "./modules/bastion"

  instance_type = var.bastion_instance_type
  key_name      = var.key_name
  subnet_id     = module.network.public_subnets[0]
  sg_id         = module.security.bastion_sg_id

  depends_on = [
    module.network,
    module.security
  ]
}

#====================================

module "storage" {
  source = "./modules/storage"

  instance_type = var.db_instance_type
  key_name      = var.key_name
  subnet_id     = module.network.private_subnets[0]
  sg_id         = module.security.mongodb_sg_id

  depends_on = [
    module.network,
    module.security
  ]
}

#====================================

module "application" {
  source = "./modules/application"

  instance_type   = var.app_instance_type
  key_name        = var.key_name
  vpc_id          = module.network.vpc_id
  public_subnets  = module.network.public_subnets
  private_subnets = module.network.private_subnets
  webserver_sg_id = module.security.application_sg_id
  alb_sg_id       = module.security.alb_sg_id
  mongodb_ip      = module.storage.private_ip

  depends_on = [
    module.network,
    module.security,
    module.storage
  ]
}


resource "aws_key_pair" "my_key_pair" {
  key_name   = var.key_name
  public_key = file("/Users/josuebustos/.ssh/terraform_ca.pub")
  # public_key = file("${abspath(path.cwd)}/my-key.pub")
}

# 98.159.85.30/32
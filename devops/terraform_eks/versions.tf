terraform {
  required_version = ">= 1.0.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9.0"
    }
  }
  backend "s3" {
    bucket         = "s3uniquename-backendbucket"
    key            = "ekstest-terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ddb-terraform-eks-statelock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-west-1"
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  availability_zone    = var.availability_zone
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  cluster_name         = var.cluster_name
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_id
  node_groups     = var.node_groups
}


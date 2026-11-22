terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 4.67" }
  }
}

provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "dr"
  region = "eu-west-1"
}

variable "region" {
  default = "eu-west-1"
}

locals {
  engine = "postgres"
}

resource "aws_db_instance" "payments" {
  engine                  = local.engine
  engine_version          = "11.22"
  multi_az                = false
  backup_retention_period = 0
  deletion_protection     = false
}

resource "aws_db_instance" "payments_replica" {
  provider       = aws.dr
  engine         = "postgres"
  engine_version = var.engine_version
  multi_az       = true
}

resource "aws_lambda_function" "settle" {
  function_name = "settle"
  runtime       = "python3.8"
}

resource "aws_eks_cluster" "main" {
  name    = "payments"
  version = "1.27"
}

resource "aws_autoscaling_group" "web" {
  vpc_zone_identifier = ["subnet-a", "subnet-b", "subnet-c"]
  desired_capacity    = 3
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"
}

module "net" {
  source = "./modules/net"
}

module "dns" {
  source = "git::https://example.com/acme/dns.git?ref=v1.4.0"
}

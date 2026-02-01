terraform {
  required_providers {
    aptible = {
      source  = "aptible/aptible"
      version = "~> 0.8.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "aptible-deploy-bucket"
    region = "us-east-2"
    dynamodb_table = "terraform-state"
  }
}

provider "aptible" {
}

provider "aws" {
  region = var.aws_region
}

# Variables
variable "ecr_password" {
  description = "ECR authentication token"
  type        = string
  sensitive   = true
}

variable "aptible_org_id" {
  description = "Aptible Organization ID (UUID)"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "aws_region" {
  description = "AWS Region for ECR"
  type        = string
}
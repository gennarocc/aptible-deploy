# Configure the Aptible provider
terraform {
  required_providers {
    aptible = {
      source  = "aptible/aptible"
      version = "~> 0.8.0"
    }
  }
}

provider "aptible" {
}

# Stack
data "aptible_stack" "main" {
  name = "shared-us-east-1-teal"
}

# Environment - create resource if it doesn't exist
resource "aptible_environment" "main" {
  stack_id = data.aptible_stack.main.stack_id
  org_id   = var.aptible_org_id
  handle   = "aptible-deploy-main"
}

# Create the app (frontend or backend based on variable)
resource "aptible_app" "app" {
  env_id = aptible_environment.main.env_id
  handle = var.app_handle
  
  config = {
    "APTIBLE_DOCKER_IMAGE" = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.ecr_repository}:latest"
    "APTIBLE_PRIVATE_REGISTRY_USERNAME" = "AWS"
    "APTIBLE_PRIVATE_REGISTRY_PASSWORD" = var.ecr_password
  }
  
  service {
    process_type           = "cmd"
    container_count        = 1
    container_memory_limit = 1024
  }
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

variable "app_handle" {
  description = "App handle (frontend or backend)"
  type        = string
}

variable "ecr_repository" {
  description = "ECR repository name"
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
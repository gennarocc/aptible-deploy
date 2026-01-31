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

# Reference existing environment
data "aptible_environment" "main" {
  handle = "aptible-deploy-main"
}

# Reference existing app instead of creating it
data "aptible_app" "app" {
  env_id = data.aptible_environment.main.env_id
  handle = var.app_handle
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
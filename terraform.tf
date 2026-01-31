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
  org_id   = data.aptible_stack.main.org_id
  handle   = "gennaro-test"
}

# Create the frontend app
resource "aptible_app" "frontend" {
  env_id = data.aptible_environment.main.env_id
  handle = "frontend"
  
  config = {
    # Required for Direct Docker Image Deployment
    "APTIBLE_DOCKER_IMAGE" = "943818144040.dkr.ecr.us-east-2.amazonaws.com/frontend:latest"
    "APTIBLE_PRIVATE_REGISTRY_USERNAME" = "AWS"
    "APTIBLE_PRIVATE_REGISTRY_PASSWORD" = var.ecr_password
  }
  
  service {
    process_type           = "cmd"
    container_count        = 1
    container_memory_limit = 1024
  }
}

variable "ecr_password" {
  description = "ECR authentication token"
  type        = string
  sensitive   = true
}

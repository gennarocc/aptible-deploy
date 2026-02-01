# Aptible Stack
data "aptible_stack" "main" {
  name = "shared-us-east-1-teal"
}

# Aptible Environment
resource "aptible_environment" "main" {
  stack_id = data.aptible_stack.main.stack_id
  org_id   = var.aptible_org_id
  handle   = "aptible-deploy-main"
}

# Frontend App
resource "aptible_app" "frontend" {
  env_id = aptible_environment.main.env_id
  handle = "frontend"
  
  config = {
    "APTIBLE_DOCKER_IMAGE" = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/frontend:latest"
    "APTIBLE_PRIVATE_REGISTRY_USERNAME" = "AWS"
    "APTIBLE_PRIVATE_REGISTRY_PASSWORD" = var.ecr_password
  }
  
  service {
    process_type           = "cmd"
    container_count        = 1
    container_memory_limit = 1024
  }
}

# Backend App
resource "aptible_app" "backend" {
  env_id = aptible_environment.main.env_id
  handle = "backend"
  
  config = {
    "APTIBLE_DOCKER_IMAGE" = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/backend:latest"
    "APTIBLE_PRIVATE_REGISTRY_USERNAME" = "AWS"
    "APTIBLE_PRIVATE_REGISTRY_PASSWORD" = var.ecr_password
  }
  
  service {
    process_type           = "cmd"
    container_count        = 1
    container_memory_limit = 1024
  }
}
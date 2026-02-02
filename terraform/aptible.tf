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
    # "REDIS_URL": aptible_database.redis.default_connection_url,
    # "DATABASE_URL": aptible_database.postgresql.default_connection_url,
  }
  
  service {
    process_type           = "cmd"
    container_count        = 1
    container_memory_limit = 1024
  }
}

# Redis Database
# resource "aptible_database" "redis" {
#   env_id         = aptible_environment.main.env_id
#   handle         = "redis"
#   database_type  = "redis"
#   container_size = 512
#   disk_size      = 10
#   version        = "5.0"
# }

# Frontend Endpoint
# resource "aptible_endpoint" "frontend" {
#   env_id         = aptible_environment.main.env_id
#   default_domain = true
#   internal       = false
#   platform       = "alb"
#   process_type   = "cmd"
#   endpoint_type  = "https"
#   resource_id    = aptible_app.frontend.app_id
#   resource_type  = "app"
#   ip_filtering   = []
#   
#   depends_on = [aptible_app.frontend]
# }

# Backend Endpoint
# resource "aptible_endpoint" "backend" {
#   env_id         = aptible_environment.main.env_id
#   default_domain = true
#   internal       = true
#   platform       = "alb"
#   process_type   = "cmd"
#   endpoint_type  = "https"
#   resource_id    = aptible_app.backend.app_id
#   resource_type  = "app"
#   ip_filtering   = []
#   
#   depends_on = [aptible_app.backend]
# }



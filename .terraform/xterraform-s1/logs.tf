# Create CloudWatch Log Group for App Container
resource "aws_cloudwatch_log_group" "lg_www" {
  name = "/ecs/${local.app_name_env}-www"

  retention_in_days = var.log_retention_in_days

  tags = {
    deployer = "terraform"
    app      = var.app_name
    env      = var.app_env
  }
}

# Create CloudWatch Log Group for Redis Container
resource "aws_cloudwatch_log_group" "lg_redis" {
  name = "/ecs/${local.app_name_env}-redis"

  retention_in_days = var.log_retention_in_days

  tags = {
    deployer = "terraform"
    app      = var.app_name
    env      = var.app_env
  }
}

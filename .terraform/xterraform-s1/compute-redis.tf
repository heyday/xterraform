# Create Elastic Container Service Redis Task
module "ecs_task_definition_redis" {
  source  = "umotif-public/ecs-fargate-task-definition/aws"
  version = "~> 2.0.0"

  enabled              = true
  name_prefix          = "${local.app_name_env}-redis"
  task_container_image = "redis:alpine"

  container_name      = "${local.app_name_env}-redis"
  task_container_port = "6379"
  task_host_port      = "6379"

  task_definition_cpu    = "512"
  task_definition_memory = "1024"

  task_container_environment = {
    "ENV" = "test"
  }

  cloudwatch_log_group_name = aws_cloudwatch_log_group.lg_redis.name

  task_container_command = [
    "redis-server",
    "--save \"\"",
    "--appendonly no"
  ]

  task_stop_timeout = 90
}

# Create Private Namespace for Redis Container
resource "aws_service_discovery_private_dns_namespace" "private_namespace_redis" {
  name = "${local.app_name_env}-redis-private-namespace"
  vpc  = module.vpc.vpc_id

  tags = {
    deployer = "terraform"
    app      = var.app_name
    env      = var.app_env
  }
}

# Create Discovery Service for Redis Container
resource "aws_service_discovery_service" "discovery_service_redis" {
  name = "${local.app_name_env}-redis-discovery-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.private_namespace_redis.id

    dns_records {
      ttl  = 60
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

# Create Elastic Container Service Redis Service
resource "aws_ecs_service" "ecs_service_redis" {
  count = var.cache_service ? 1 : 0

  name = "${local.app_name_env}-redis"

  cluster = aws_ecs_cluster.ecs.id

  task_definition = module.ecs_task_definition_redis.task_definition_arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    assign_public_ip = false
    subnets          = module.vpc.private_subnets
    security_groups = [
      module.sg_redis.this_security_group_id
    ]
  }

  service_registries {
    registry_arn = aws_service_discovery_service.discovery_service_redis.arn
  }
}

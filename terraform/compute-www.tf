# Create Elastic Container Service Cluster
resource "aws_ecs_cluster" "ecs" {
  name = local.app_name_env
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# Create Elastic Container Service App Task
module "ecs_task_definition_www" {
  source  = "umotif-public/ecs-fargate-task-definition/aws"
  version = "~> 2.0.0"

  enabled              = true
  name_prefix          = "${local.app_name_env}-www"
  task_container_image = "firstlookmedia/placeholder-app:latest"

  container_name      = "${local.app_name_env}-www"
  task_container_port = "80"
  task_host_port      = "80"

  task_definition_cpu    = var.task_cpu
  task_definition_memory = var.task_memory

  task_container_environment = {
    "ENV" = "test"
  }

  cloudwatch_log_group_name = aws_cloudwatch_log_group.lg_www.name

  task_stop_timeout = 90
}

# Create Elastic Container Service App Service
resource "aws_ecs_service" "ecs_service_www" {
  name = "${local.app_name_env}-www"

  cluster = aws_ecs_cluster.ecs.id

  task_definition = module.ecs_task_definition_www.task_definition_arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    assign_public_ip = false
    subnets          = module.vpc.private_subnets
    security_groups = [
      module.sg_ecs.security_group_id
    ]
  }

  load_balancer {
    target_group_arn = module.alb.target_group_arns[0]
    container_name   = "${local.app_name_env}-www"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [
      task_definition,
      desired_count
    ]
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.tasks_desired_count
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.ecs.name}/${aws_ecs_service.ecs_service_www.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

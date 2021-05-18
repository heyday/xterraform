# Create Relational Database Service Aurora MySQL
module "db" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 2.0"

  create_cluster = var.db

  name = local.app_name_env

  engine         = "aurora-mysql"
  engine_mode    = var.db_engine_mode
  engine_version = var.db_engine_mode == "serverless" ? null : "5.7.mysql_aurora.2.07.2"

  vpc_id  = module.vpc.vpc_id
  subnets = var.db_external_access ? module.vpc.public_subnets : module.vpc.private_subnets

  replica_count          = var.db_engine_mode == "serverless" ? 0 : var.db_replica_count // no instance if serverless
  vpc_security_group_ids = [module.sg_db.security_group_id]
  create_security_group  = false
  instance_type          = var.db_instance_type
  storage_encrypted      = true
  apply_immediately      = true
  monitoring_interval    = 10
  enable_http_endpoint   = var.db_engine_mode == "serverless" ? true : false

  username = var.app_name
  password = var.db_password

  db_parameter_group_name         = aws_db_parameter_group.aurora_db_57_parameter_group.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_57_cluster_parameter_group.id
  publicly_accessible             = var.db_external_access

  enabled_cloudwatch_logs_exports = var.db_engine_mode == "serverless" ? [] : ["audit", "error", "general", "slowquery"] // automatic log export if serverless

  skip_final_snapshot = true

  tags = {
    deployer = "terraform"
    app      = var.app_name
    env      = var.app_env
  }
}

# Create DB Parameter Group
resource "aws_db_parameter_group" "aurora_db_57_parameter_group" {
  name        = "${local.app_name_env}-aurora-db-57-parameter-group"
  family      = "aurora-mysql5.7"
  description = "test-aurora-db-57-parameter-group"
}

# Create Cluster Parameter Group
resource "aws_rds_cluster_parameter_group" "aurora_57_cluster_parameter_group" {
  name        = "${local.app_name_env}-aurora-57-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "test-aurora-57-cluster-parameter-group"
}

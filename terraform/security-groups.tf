# Create a Security Group for Application Load Balancer
module "sg_alb" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${local.app_name_env}-alb"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks      = var.whitelisted_ips
  ingress_with_cidr_blocks = [
    {
      rule        = "https-443-tcp"
    },
    {
      rule        = "http-80-tcp"
    },
  ]
  
  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_rules            = ["all-all"]

  tags = {
    deployer = "terraform"
    app      = var.app_name
    env      = var.app_env
  }
}

# Create a Security Group for Elastic Container Service
module "sg_ecs" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${local.app_name_env}-ecs"
  vpc_id      = module.vpc.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = "${module.sg_alb.this_security_group_id}"
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_rules            = ["all-all"]

  tags = {
    deployer = "terraform"
    app      = var.app_name
    env      = var.app_env
  }
}

# Create a Security Group for Redis Container
module "sg_redis" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${local.app_name_env}-redis"
  vpc_id      = module.vpc.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "redis-tcp"
      source_security_group_id = "${module.sg_ecs.this_security_group_id}"
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_rules            = ["all-all"]

  tags = {
    deployer = "terraform"
    app      = var.app_name
    env      = var.app_env
  }
}

# Create a Security Group for Redis Container
module "sg_db" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${local.app_name_env}-db"
  vpc_id      = module.vpc.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = "${module.sg_ecs.this_security_group_id}"
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  ingress_cidr_blocks      = var.whitelisted_ips
  ingress_rules            = ["mysql-tcp"]

  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_rules            = ["all-all"]

  tags = {
    deployer = "terraform"
    app      = var.app_name
    env      = var.app_env
  }
}
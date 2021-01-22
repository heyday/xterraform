# Application Variables

app_name = "app" // Name of the project/application
app_env = "test" // Environment type

# Provider Variables

aws_region = "ap-southeast-2" // Selected AWS region
aws_profile = "profile" // Selected AWS profile

# Network Variables 

vpc_cidr_block = "10.0.0.0/16" // VPC main CIDR block
vpc_azs = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"] // VPC main CIDR block

# Subnets
# 
# If you have 2 VPCs that needs to share resources, use different subnets. Example:
#
# - VPC 1:
#   - private = ["10.0.0.0/24", "10.0.1.0/24"] 
#   - public = ["10.0.2.0/24", "10.0.3.0/24"] 
# - VPC 2:
#   - private = ["10.0.4.0/24", "10.0.5.0/24"] 
#   - public = ["10.0.6.0/24", "10.0.7.0/24"] 
#
# Notice that all the subnets are different
vpc_private_subnets = ["10.0.0.0/24", "10.0.1.0/24"] 
vpc_public_subnets  = ["10.0.2.0/24", "10.0.3.0/24"] 

whitelisted_ips = ["52.64.201.74/32","124.157.86.242/32"] // Initial IPs which can access the stack. Set to ["0.0.0.0/0"] for public access

# Compute Variables 

cache_service = false // If true, Redis service, task definition, and container are created
task_cpu = 512 // Task definition CPU in MB
task_memory = 1024 // Task definition RAM in MB
tasks_desired_count = 2 // Main app minimum task count, for load balancing target
log_retention_in_days = 7 // Amount of days before the container log gets wiped out

# Database Variables

db = false // If true, a DB cluster is created
db_password = "default_db_password" // Initial password for DB
db_engine_mode = "serverless" // Available type: global, parallelquery, provisioned, serverless, multimaster
db_replica_count = 1 // DB replica count, no need to specify if db_engine_mode is serverless
db_instance_type = "db.t2.small" // DB instance tier type, no need to specify if db_engine_mode is serverless
db_external_access = false // If true, external ip can access DB

# Storage Variables

storage = false // If true, a storage is created
storage_cdn = false // If true, create storage distribution (CDN)
storage_principal_arn = "" // User/Role ARN with admin access to S3
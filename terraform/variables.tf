# Application Variables

variable "app_name" {
  type = string
}

variable "app_env" {
  type = string
}

# Provider Variables

variable "aws_region" {
  type = string
}

variable "aws_profile" {
  type = string
}

# Network Variables

variable "vpc_cidr_block" {
  type = string
}

variable "vpc_azs" {
  type = list(string)
}

variable "vpc_private_subnets" {
  type = list(string)
}

variable "vpc_public_subnets" {
  type = list(string)
}

variable "whitelisted_ips" {
  type = list(string)
}

# Compute Variables

variable "cache_service" {
  type = bool
}

variable "task_cpu" {
  type = number
}

variable "task_memory" {
  type = number
}

variable "tasks_desired_count" {
  type = number
}

variable "log_retention_in_days" {
  type = number
}

# Database Variables

variable "db" {
  type = bool
}

variable "db_password" {
  type = string
}

variable "db_engine_mode" {
  type = string
}

variable "db_replica_count" {
  type = number
}

variable "db_instance_type" {
  type = string
}

variable "db_external_access" {
  type = bool
}

# Storage Variables

variable "storage" {
  type = bool
}

variable "storage_cdn" {
  type = bool
}

variable "storage_principal_arn" {
  type = string
}

# Processed Variables

locals {
  app_name_env = "${var.app_name}-${var.app_env}"
}

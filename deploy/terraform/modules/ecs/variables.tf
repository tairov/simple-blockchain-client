variable "project" {
  description = "Project name"
}

# environment name: dev, prod, stage, test, qa
variable "env" {
  description = "Project environment"
}

variable "region" {
  default     = "us-east-1"
  description = "AWS Region"
}

variable "ecs_launch_type" {
  default = "FARGATE"
}

variable "subnet_1_id" {}

variable "subnet_2_id" {}

variable "web_target_group_arn" {}

variable "app_security_groups" {}


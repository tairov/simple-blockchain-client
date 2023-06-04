variable "project" {
  description = "Project name"
}

# environment name: production, staging, qa, dev
variable "env" {
  description = "Project environment"
}

variable "region" {
  default     = "eu-central-1"
  description = "AWS Region"
}

variable "vpc_cidr" {
  description = "CIDR Block for VPC"
}

variable "public_subnet_1_cidr" {
  description = "CIDR Block for Public Subnet 1"
}

variable "public_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 2"
}

variable "private_subnet_1_cidr" {
  description = "CIDR Block for Private Subnet 1"
}

variable "private_subnet_2_cidr" {
  description = "CIDR Block for Private Subnet 2"
}

variable "db_subnet_1_cidr" {
  description = "CIDR Block for Db Subnet 1"
}

variable "db_subnet_2_cidr" {
  description = "CIDR Block for Db Subnet 2"
}

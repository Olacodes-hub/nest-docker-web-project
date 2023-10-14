# environment variables
variable "region" {
  description = "region to create resources"
  type        = string
}

variable "PROJECT_NAME" {
  description = "project name"
  type        = string
}


variable "ENVIRONMENT" {
  description = "environment"
  type        = string
}

# vpc variables
variable "vpc_cidr" {
  description = "vpc cidr block"
  type        = string
}

variable "public_subnet_az1_cidr" {
  description = "public subnet az1 cidr block"
  type        = string
}

variable "public_subnet_az2_cidr" {
  description = "public subnet az2 cidr block"
  type        = string
}

variable "private_app_subnet_az1_cidr" {
  description = "private app subnet az1 cidr block"
  type        = string
}

variable "private_app_subnet_az2_cidr" {
  description = "private app subnet az2 cidr block"
  type        = string
}

variable "private_data_subnet_az1_cidr" {
  description = "private data subnet az1 cidr block"
  type        = string
}

variable "private_data_subnet_az2_cidr" {
  description = "private data subnet az2 cidr block"
  type        = string
}

variable "rds_db_name" {}
variable "instance_class" {}
variable "availability_zone_1" {}
variable "username" {}
variable "password" {}

variable "DOMAIN_NAME" {}
variable "ALTERNATIVE_NAMES" {}

# create iam variables
variable "role_name" {}

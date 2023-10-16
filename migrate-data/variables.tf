variable "amazon_linux_ami_id" {
  description = "The ID of the Amazon Linux AMI"
  type        = string
}

variable "ec2_instance_type" {
  description = "The type of EC2 instance"
  type        = string
}

variable "private_app_subnet_az1_id" {
  description = "The ID of the private app subnet in availability zone 1"
  type        = string
}

variable "app_server_security_group_id" {
  description = "The ID of the app server security group"
  type        = string
}

variable "eice_security_group_id" {
  description = "The ID of the EICE security group"
  type        = string
}

variable "RDS_ENDPOINT" {
  description = "The RDS endpoint"
  type        = string
}

variable "RDS_DB_NAME" {
  description = "The name of the RDS database"
  type        = string
}

variable "USERNAME" {
  description = "The username for something"
  type        = string
}

variable "PASSWORD" {
  description = "The password for something"
  type        = string
}

variable "PROJECT_NAME" {
  description = "The name of the project"
  type        = string
}

variable "ENVIRONMENT" {
  description = "The environment of the project"
  type        = string
}

variable "DOMAIN_NAME" {
  description = "The domain name"
  type        = string
}

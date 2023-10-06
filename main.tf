
locals {
  region       = var.region
  PROJECT_NAME = var.PROJECT_NAME
  ENVIRONMENT  = var.ENVIRONMENT

}

#create vpc module
module "vpc" {
  source       = "git@github.com:Olacodes-hub/nest-docker-web-project.git//vpc"
  region       = local.region
  PROJECT_NAME = local.PROJECT_NAME
  ENVIRONMENT  = local.ENVIRONMENT
  # vpc variables
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
}
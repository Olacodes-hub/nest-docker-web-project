
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

# create nat gateway
module "nat-gateway" {
  source                     = "git@github.com:Olacodes-hub/nest-docker-web-project.git//nat-gateway"
  vpc_id                     = module.vpc.vpc_id
  internet_gateway           = module.vpc.internet_gateway
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id  = module.vpc.private_app_subnet_az2_id
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id


}

# create security groups
module "security-group" {
  source = "git@github.com:Olacodes-hub/nest-docker-web-project.git//security-group"
  vpc_id = module.vpc.vpc_id
}
# create rds instance
module "name" {
  source                     = "git@github.com:Olacodes-hub/nest-docker-web-project.git//rds"
  rds_db_name                = var.rds_db_name
  instance_class             = var.instance_class
  username                   = var.username
  password                   = var.password
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id
  availability_zone_1        = module.vpc.availability_zone_1
  database_security_group_id = [module.security-group.database_security_group_id]

}
output "rds_endpoint" {
  value = aws_db_instance.rds_instance.endpoint
}






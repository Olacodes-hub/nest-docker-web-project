
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
module "rds" {
  source                     = "git@github.com:Olacodes-hub/nest-docker-web-project.git//rds"
  db_name              = var.RDS_DB_NAME
  instance_class             = var.instance_class
  username                   = var.USERNAME
  password                   = var.PASSWORD
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id
  availability_zone_1        = module.vpc.availability_zone_1
  database_security_group_id = [module.security-group.database_security_group_id]

}
module "acm" {
  source            = "git@github.com:Olacodes-hub/nest-docker-web-project.git//acm"
  DOMAIN_NAME       = var.DOMAIN_NAME
  ALTERNATIVE_NAMES = var.ALTERNATIVE_NAMES

}

module "iam" {
  source    = "git@github.com:Olacodes-hub/nest-docker-web-project.git//iam"
  role_name = var.role_name

}

module "eice" {
  source                    = "git@github.com:Olacodes-hub/nest-docker-web-project.git//eice"
  private_app_subnet_az1_id = module.vpc.private_app_subnet_az1_id
  eice_security_group_id    = toset([module.security-group.eice_security_group_id])

}
module "migrate-data" {
  source                       = "git@github.com:Olacodes-hub/nest-docker-web-project.git//migrate-data"
  amazon_linux_ami_id          = var.amazon_linux_ami_id
  ec2_instance_type            = var.ec2_instance_type
  private_app_subnet_az1_id    = module.vpc.private_app_subnet_az1_id
  app_server_security_group_id = module.security-group.app_server_security_group_id
  eice_security_group_id       = module.security-group.eice_security_group_id
  RDS_ENDPOINT                 = module.rds.RDS_ENDPOINT
  db_name                  = module.rds.RDS_DB_NAME
  USERNAME                   = var.USERNAME
  PASSWORD                 = var.PASSWORD
  PROJECT_NAME                 = module.vpc.PROJECT_NAME
  ENVIRONMENT                  = module.vpc.ENVIRONMENT
  DOMAIN_NAME                  = module.acm.DOMAIN_NAME

}
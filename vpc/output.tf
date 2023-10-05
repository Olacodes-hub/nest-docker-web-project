# export the region
output "region" {
  value = var.region
}

# export the project name
output "project_name" {
  value = var.PROJECT_NAME
}

# export the environment
output "environment" {
  value = var.ENVIRONMENT
}

# export the vpc id
output "vpc_id" {
  value = var.vpc_cidr
}

# export the internet gateway
output "internet_gateway" {
  value = aws_internet_gateway.gateway.id
}

# export the public subnet az1 id
output "public_subnet_az1_id" {
  value = aws_subnet.public_subnet_az1.id
}

# export the public subnet az2 id
output "public_subnet_az2_id" {
  value = aws_subnet.public_subnet_az2.id
}

# export the private app subnet az1 id
output "private_app_subnet_az1_id" {
  value = 
}

# export the private app subnet az2 id
output "private_app_subnet_az2_id" {
  value = 
}

# export the private data subnet az1 id
output "private_data_subnet_az1_id" {
  value = 
}

# export the private data subnet az2 id
output "private_data_subnet_az2_id" {
  value = 
}

# export the first availability zone
output "availability_zone_1" {
  value = 
}

# export the second availability zone
output "availability_zone_2" {
  value = 
}
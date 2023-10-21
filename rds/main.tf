# create database subnet group
resource "aws_db_subnet_group" "database_subnet_group1" {
  name        = "subnet-groups-1"
  subnet_ids  = [var.private_data_subnet_az1_id, var.private_data_subnet_az2_id]
  description = "subnets for rds instance"

  tags = {
    Name = "subnet-groups"
  }
}

# create rds database
resource "aws_db_instance" "database_instance"  {
  engine                 = "mysql"
  engine_version         = "8.0.34"
  multi_az               = false
  identifier             = "nest-db"
  username              = var.username
  password               = var.password
  db_name               = var.db_name
  instance_class         = var.instance_class
  allocated_storage      = 20
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids = var.database_security_group_id
  availability_zone      = var.availability_zone_1
  skip_final_snapshot    = true
  publicly_accessible    = false
}







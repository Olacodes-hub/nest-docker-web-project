# create database subnet group
resource "aws_db_subnet_group" "database_subnet_group" {
  name        = "subnet-groups"
  subnet_ids  = [aws_subnet.private_data_subnet_az1.id, aws_subnet.private_data_subnet_az2.id]
  description = "subnets for rds instance"

  tags = {
    Name = "subnet-groups"
  }
}

# create rds database
resource "aws_db_instance" "database_instance" {
  engine                 = "mysql"
  engine_version         = "8.0.34"
  multi_az               = false
  identifier             = "nest-db"
  username               = local.USERNAME
  password               = local.PASSWORD
  db_name                = local.RDS_DB_NAME
  instance_class         = "db.t2.micro"
  allocated_storage      = 20
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids = [aws_security_group.database_security_group.id]
  availability_zone      = "us-east-1b"
  skip_final_snapshot    = true
  publicly_accessible    = false
}

output "rds_endpoint" {
  value = aws_db_instance.database_instance.endpoint
}






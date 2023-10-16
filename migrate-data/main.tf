resource "aws_instance" "data_migrate_ec2" {
  ami                    = var.amazon_linux_ami_id
  instance_type          = var.ec2_instance_type
  subnet_id              = var.private_app_subnet_az1.id
  vpc_security_group_ids = [var.app_server_security_group_id, var.eice_security_group_id]
  iam_instance_profile   = var.iam_instance_profile


  user_data = base64encode(templatefile("${path.module}/migrate-nest-sql.sh.tpl", {
    RDS_ENDPOINT = var.RDS_ENDPOINT
    rds_db_name  = var.RDS_DB_NAME
    usernamne    = var.USERNAME
    password    = var.PASSWORD
    PROJECT_NAME = var.PROJECT_NAME
    ENVIRONMENT  = var.ENVIRONMENT
    RECORD_NAME  = var.RECORD_NAME
    DOMAIN_NAME  = var.DOMAIN_NAME
    
    

  }))

  depends_on = [aws_db_instance.database_instance]

  tags = {
    Name = "nest-ec2-migrate"
  }
}


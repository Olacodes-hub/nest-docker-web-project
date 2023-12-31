resource "aws_instance" "data_migrate_ec2" {
  ami                    = var.amazon_linux_ami_id
  instance_type          = var.ec2_instance_type
  subnet_id              = var.private_app_subnet_az1_id
  vpc_security_group_ids = [var.app_server_security_group_id, var.eice_security_group_id]
  iam_instance_profile   = var.iam_instance_profile

  user_data = base64encode(templatefile("/Users/safo/nest-docker-web-project/user_data_template.sh.tpl", {
    rds_endpoint = var.rds_endpoint,
    rds_db_name  = var.rds_db_name,
    username     = var.username,
    password     = var.password
  }))
}
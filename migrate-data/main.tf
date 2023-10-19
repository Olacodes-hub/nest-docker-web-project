
resource "aws_instance" "data_migrate_ec2" {
  ami                    = var.amazon_linux_ami_id
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.private_app_subnet_az1.id
  vpc_security_group_ids = [aws_security_group.webserver_sg.id, aws_security_group.eice_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.s3_full_access_instance_profile.id


  user_data = base64encode(templatefile("${path.module}/install-and-configure-nest-app.sh.tpl", {
    RDS_ENDPOINT = aws_db_instance.database_instance.endpoint
    db_name = var.db_name
    username     = var.username
    password     = var.password

  }))

  depends_on = [aws_db_instance.database_instance]

  tags = {
    Name = "nest-ec2-migrate"
  }
}
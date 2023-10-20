output "rds_endpoint" {
  value = aws_db_instance.database_instance.endpoint
  
}

output "rds_instance" {
  value = aws_db_instance.database_instance.id
  
}

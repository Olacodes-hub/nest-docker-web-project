output "rds_endpoint" {
  value = aws_db_instance.database_instance.endpoint
  
}
output "database-instance-id" {
  value = aws_db_instance.database_instance.id
  
}
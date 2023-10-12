
output "rds_endpoint" {
  description = "The endpoint (hostname) of the RDS instance"
  value       = module.rds_instance.endpoint
}

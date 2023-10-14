output "aws_iam_role" {
  value = aws_iam_role.s3_full_access_role.name
}

output "iam_role_arn" {
  value = aws_iam_role.s3_full_access_role.arn
}

output "iam_instance_profile" {
  value = aws_iam_instance_profile.s3_full_access_instance_profile.name
}

output "iam_instance_profile_arn" {
  value = aws_iam_instance_profile.s3_full_access_instance_profile.arn
}
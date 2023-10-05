
# store the terraform state file in s3 and lock with dynamodb
terraform {
  backend "s3" {
    bucket         = "nest-terraform-state"
    key            = "docker-nest1/terraform-tfstate"
    region         = "us-east-1"
    profile        = "nest1"
    dynamodb_table = "terraform-state-loc"

  }
}
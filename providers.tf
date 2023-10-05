
# configure aws provider to establish a secure connection between terraform and aws
provider "aws" {
  region  = "var.region"
  profile = "nest1"

  default_tags {
    tags = {
      "Automation"  = terraform
      "Project"     = var.PROJECT-NAME
      "Environment" = var.ENVIRONMENT
    }
  }
}
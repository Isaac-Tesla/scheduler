provider "aws" {
  region = var.region
  shared_credentials_files = ["~/.aws/credentials"]
  profile = "default"
}

# https://www.terraform.io/docs/language/settings/backends/s3.html
terraform {
  backend "s3" {
    bucket = ""
    key    = "statefile/devops/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

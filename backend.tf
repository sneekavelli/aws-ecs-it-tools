terraform {
  backend "s3" {
    bucket         = "YOUR-UNIQUE-TERRAFORM-STATE-BUCKET" # S3 bucket name for storing Terraform state
    key            = "it-tools/production/terraform.tfstate" # Path within the bucket to store the state file
    region         = "eu-west-2"                          # Change to your AWS region (e.g., us-east-1 or eu-west-2)
    dynamodb_table = "terraform-state-lock"               # Used to prevent concurrent pipeline runs
    encrypt        = true
  }
}
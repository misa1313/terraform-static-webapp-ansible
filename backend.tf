terraform {
  backend "s3" {
    bucket                  = "tfstatus-bucket"
    dynamodb_table          = "terraform_locks-m"
    key                     = "terraform-state"
    region                  = "us-east-2"
  }
}

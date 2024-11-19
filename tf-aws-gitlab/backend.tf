terraform {
  backend "s3" {
    bucket         = "s3-remote-backend-20240824160957126100000001"
    key            = "terra-backend/terraform.tfstate"
    encrypt        = true
    region         = "us-east-2"
    dynamodb_table = "terraform-state-lock-dynamo1"
  }
}


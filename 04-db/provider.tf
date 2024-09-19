terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.67.0"
    }
  }
backend "s3" {
  bucket = "expense-dev-remote-state"
  key = "expense-tf-dev-db"
  region = "us-east-1"
  dynamodb_table = "expense-locking"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}


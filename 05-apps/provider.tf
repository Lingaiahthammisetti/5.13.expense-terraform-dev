terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.58.0"
    }
  }
backend "s3" {
  bucket ="expense-terraform-dev"
  key="expense-terraform-dev-apps"
  region="us-east-1"
  dynamodb_table="expense-terraform-dev"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}


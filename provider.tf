terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"   # pick a stable version
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws-access-key-id
  secret_key = var.aws-secret-access-key
}


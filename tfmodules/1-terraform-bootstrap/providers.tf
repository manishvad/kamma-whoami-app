terraform {
  required_providers {
    aws = "~> 4"
  }
}

provider "aws" {
  region = "eu-west-1"
  assume_role {
    role_arn = "arn:aws:iam::521231545277:role/AdminRole"
  }
}


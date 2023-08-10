terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-kamma"
    key    = "aws/deployment-role"
    region = "eu-west-1"
    role_arn = "arn:aws:iam::521231545277:role/terraform_bootstrap_role"
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-kamma"
    key    = "aws/build-k8s-environment"
    region = "eu-west-1"
    role_arn = "arn:aws:iam::521231545277:role/deployment_role"
  }
}

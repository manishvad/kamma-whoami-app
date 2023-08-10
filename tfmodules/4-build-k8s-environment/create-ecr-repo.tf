# Create ECR repo
resource "aws_ecr_repository" "kamma_ecr_repo" {
  name                 = "kamma-ecr-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
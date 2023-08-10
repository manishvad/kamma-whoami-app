resource "aws_iam_role" "deployment_role" {
  name        = "deployment_role"
  description = "deployment_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "arn:aws:iam::${var.aws_account_number}:user/${var.aws_account_username}"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kamma_terraform_state_bucket" {
  role       = aws_iam_role.deployment_role.name
  policy_arn = aws_iam_policy.kamma_terraform_state_bucket_access.arn
}

resource "aws_iam_role_policy_attachment" "kamma_project_roles" {
  role       = aws_iam_role.deployment_role.name
  policy_arn = aws_iam_policy.kamma_project_roles.arn
}

resource "aws_iam_role_policy_attachment" "kamma_ecr_access" {
  # allow access to view ECR repos from the console
  role       = aws_iam_role.deployment_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

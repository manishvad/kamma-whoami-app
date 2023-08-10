resource "aws_iam_role" "terraform_bootstrap_role" {
  name        = "terraform_bootstrap_role"
  description = "terraform_bootstrap_role"

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

resource "aws_iam_role_policy_attachment" "terraform_bootstrap_role_1" {
  role       = aws_iam_role.terraform_bootstrap_role.name
  policy_arn = aws_iam_policy.tfbootstrap_policy_1.arn
}

resource "aws_iam_role_policy_attachment" "terraform_bootstrap_role_2" {
  role       = aws_iam_role.terraform_bootstrap_role.name
  policy_arn = aws_iam_policy.tfbootstrap_policy_2.arn
}
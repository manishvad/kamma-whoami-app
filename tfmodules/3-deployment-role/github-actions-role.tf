# Creates github actions role so allow us to push ecr images to amazon
# This role is assumed when github pipeline runs

module "iam_github_oidc_provider" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
  url = "https://token.actions.githubusercontent.com"
  create = true
  client_id_list = ["sts.amazonaws.com"]
  tags = {
    Environment = "github-actions-identity-provider"
  }
}

resource "aws_iam_role" "github_actions_role" {
  name = "github-actions-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::${var.aws_account_number}:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                }
            }
        }
    ]
 })
 depends_on = [module.iam_github_oidc_provider]
}

resource "aws_iam_role_policy_attachment" "github_actions_role" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

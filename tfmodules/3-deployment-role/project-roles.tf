data "aws_iam_policy_document" "kamma_project_roles" {
  statement {
    effect = "Allow"
    actions = [
      # allows EC2 instance creation
      "ec2:*",
      "ssm:*",
      # allows IAM instance profile creation for EC2 instance
      "iam:CreateRole",
      "iam:TagRole",
      "iam:GetRole",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:DeleteRole",
      "iam:CreateInstanceProfile",
      "iam:PutRolePolicy",
      "iam:GetInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile", 
      "iam:DeleteInstanceProfile",
      "iam:AddRoleToInstanceProfile",
      "iam:GetRolePolicy",
      "iam:DeleteRolePolicy"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      # pass role for EC2 iam instance required
      "iam:PassRole"
    ]
    resources = [
      "arn:aws:iam::${var.aws_account_number}:role/kamma_ec2_instance_role"
    ]
  }
}

resource "aws_iam_policy" "kamma_project_roles" {
  name        = "kamma_project_roles"
  path        = "/"
  description = "kamma_project_roles"
  policy = data.aws_iam_policy_document.kamma_project_roles.json
}

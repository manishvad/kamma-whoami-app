# gives permission to create bucket
# gives permission for remote state
data "aws_iam_policy_document" "tfbootstrap_policy_1" {
  statement {
    effect = "Allow"
    actions = [
      "s3:*",
      "s3:ListAllMyBuckets"
    ]
    resources = [
      "*"
    ]
  }  
}

data "aws_iam_policy_document" "tfbootstrap_policy_2" {
  statement {
    effect = "Allow"
    actions = [
      "iam:*",
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "tfbootstrap_policy_1" {
  name        = "terraform_state_bucket"
  path        = "/"
  description = "terraform_state_bucket"
  policy = data.aws_iam_policy_document.tfbootstrap_policy_1.json
}

resource "aws_iam_policy" "tfbootstrap_policy_2" {
  name        = "iam"
  path        = "/"
  description = "iam"
  policy = data.aws_iam_policy_document.tfbootstrap_policy_2.json
}
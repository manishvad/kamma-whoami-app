data "aws_iam_policy_document" "kamma_terraform_state_bucket_access" {
  # allows the role access to store state in s3 bucket
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
      "s3:GetBucketLocation",
      "s3:GetBucketVersioning",
      "s3:GetEncryptionConfiguration",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketPolicy"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListMultipartUploadParts",
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:GetObjectTagging",
      "s3:GetBucketLocation"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}/*"
    ]
  }
}

resource "aws_iam_policy" "kamma_terraform_state_bucket_access" {
  name        = "kamma_terraform_state_bucket_access"
  path        = "/"
  description = "kamma_terraform_state_bucket_access"
  policy = data.aws_iam_policy_document.kamma_terraform_state_bucket_access.json
}

## S3 state bucket
resource "aws_s3_bucket" "kamma_state_bucket" {
  bucket = "${var.bucket_name}"
}

resource "aws_s3_bucket_ownership_controls" "kamma_state_bucket" {
  bucket = aws_s3_bucket.kamma_state_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "kamma_state_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.kamma_state_bucket]

  bucket = aws_s3_bucket.kamma_state_bucket.id
  acl    = "private"
}
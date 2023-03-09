resource "aws_dynamodb_table" "terraform-lock" {
  count          = var.dynamodb_table == true ? 1 : 0
  name           = "TerraformMainStateLock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    "Name" = "DynamoDB Terraform State Lock Table"
  }

  provider = aws.primary
}

resource "aws_s3_bucket" "bucket" {
  count  = var.bucket == true ? 1 : 0
  bucket = "terraform-multi-account"
  versioning {
    enabled = true
  }

  tags = {
    Name = "S3 Remote Terraform State Store"
  }

  provider = aws.primary
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket" {
  count  = var.bucket == true ? 1 : 0
  bucket = aws_s3_bucket.bucket[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }

  provider = aws.primary
}

resource "aws_s3_bucket_versioning" "bucket" {
  count  = var.bucket == true ? 1 : 0
  bucket = aws_s3_bucket.bucket[0].id
  versioning_configuration {
    status = "Enabled"
  }

  provider = aws.primary
}
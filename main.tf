resource "aws_s3_bucket" "backup_storage" {
  bucket = var.bucket_name

  tags = {
    Function      = "backup_storage"
    Lifecycle     = "On"
    Storage_Class = "Glacier"
  }
}

resource "aws_s3_bucket_ownership_controls" "backup_storage_controls" {
  bucket = aws_s3_bucket.backup_storage.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backup_storage" {
  bucket = aws_s3_bucket.backup_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "backup_storage_version" {
  bucket = aws_s3_bucket.backup_storage.id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "backup_storage_lifecycle" {
  #ddepends_on = [ aws_s3_bucket_versioning.backup_storage_version ]
  bucket = aws_s3_bucket.backup_storage.id

  rule {
    id     = "backup_storage_lifecycle"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    transition {
      days          = 1
      storage_class = "GLACIER"
    }

    transition {
      days          = 91
      storage_class = "DEEP_ARCHIVE"
    }
  }
}

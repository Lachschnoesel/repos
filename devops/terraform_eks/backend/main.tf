resource "aws_s3_bucket" "remote_backend" {
  bucket = "s3-${var.project_name}-backend"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name         = "ddb-${var.project_name}-statelock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

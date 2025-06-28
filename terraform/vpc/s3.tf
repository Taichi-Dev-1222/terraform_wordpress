resource "aws_s3_bucket" "remote_backend" {
  bucket = "tfstate-bucket-vpc-202506" 
  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "remote-backend-s3"
  }
}

# バージョニングの設定
resource "aws_s3_bucket_versioning" "remote_backend" {
  bucket = aws_s3_bucket.remote_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}
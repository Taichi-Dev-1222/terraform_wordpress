resource "aws_s3_bucket" "wp_media" {
  bucket = "wp-media-dev-tf-wp"  
  force_destroy = true                 

  tags = {
    Name = "wp-media-dev-tf-wp"
  }
}

resource "aws_s3_bucket_public_access_block" "wp_media" {
  bucket = aws_s3_bucket.wp_media.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

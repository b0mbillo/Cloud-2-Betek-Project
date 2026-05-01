resource "aws_s3_bucket" "bucket" {
  bucket = var.s3_config.bucket_name
  tags = var.tags
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = var.s3_config.form_key_object
  }
}

resource "aws_s3_bucket_public_access_block" "access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = var.s3_config.block_public_acls
  block_public_policy     = var.s3_config.block_public_policy
  ignore_public_acls      = var.s3_config.ignore_public_acls
  restrict_public_buckets = var.s3_config.restrict_public_buckets
}

resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.bucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "form"{
    depends_on = [
      aws_s3_bucket.bucket,
      aws_s3_bucket_public_access_block.access_block,
      aws_s3_bucket_website_configuration.website
    ]
    bucket = aws_s3_bucket.bucket.id
    key    = var.s3_config.form_key_object
    source = var.s3_config.path_to_form
    content_type = "text/html"
}

output "website_url" {
  value = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
}

resource "aws_s3_object" "support"{
    depends_on = [
      aws_s3_bucket.bucket,
      aws_s3_bucket_public_access_block.access_block,
    ]
    bucket = aws_s3_bucket.bucket.id
    key    = var.s3_config.support_key_object
    source = var.s3_config.path_to_support
    content_type = "text/html"
}

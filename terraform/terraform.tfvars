s3_config = {
  bucket_name             = "bucket-NexaCloud"
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  path_to_form            = "webpage/form.html"
  form_key_object         = "webpage/form.html"
  path_to_support         = "webpage/support.html"
  support_key_object      = "webpage/support.html"
}

tags = {
  env     = "dev"
  owner   = "Brando Montoya Jaramillo"
  project = "Betek"
} 
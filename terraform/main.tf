module "s3" {
  source    = "./modules/S3"
  s3_config = var.s3_config
  tags      = var.tags
}

output "website_url" {
  value = module.s3.website_url
}


# Create Simple Storage Service Bucket
module "s3_bucket_public" {
  source = "terraform-aws-modules/s3-bucket/aws"

  create_bucket = var.storage

  bucket = "${local.app_name_env}-public"
  acl    = "private"

  versioning = {
    enabled = false
  }

  attach_policy = true
  policy        = data.aws_iam_policy_document.s3_bucket_public.json

  tags = {
    deployer = "terraform"
    app      = var.app_name
    env      = var.app_env
  }
}

# Create Simple Storage Service Bucket
module "s3_bucket_public_cdn_logs" {
  source = "terraform-aws-modules/s3-bucket/aws"

  create_bucket = var.storage_cdn

  bucket = "${local.app_name_env}-public-cdn-logs"
  acl    = "private"

  tags = {
    deployer = "terraform"
    app      = var.app_name
    env      = var.app_env
  }
}

module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  create_distribution = var.storage_cdn

  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  logging_config = {
    bucket = module.s3_bucket_public_cdn_logs.s3_bucket_bucket_domain_name
  }

  origin = {
    s3_one = {
      domain_name = module.s3_bucket_public.s3_bucket_bucket_regional_domain_name
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3_one"
    viewer_protocol_policy = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/*"
      target_origin_id       = "s3_one"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      query_string    = true
    }
  ]
}

# Create Policy for S3 Bucket
data "aws_iam_policy_document" "s3_bucket_public" {
  statement {
    sid       = "AllowGetFromAll"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${local.app_name_env}-public/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  statement {
    sid       = "AllowAllFromCli"
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::${local.app_name_env}-public/*"]
    principals {
      type        = "AWS"
      identifiers = [var.storage_principal_arn]
    }
  }
}

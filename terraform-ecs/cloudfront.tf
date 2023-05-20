resource "aws_cloudfront_distribution" "cloudfront" {
  origin {
    domain_name = aws_s3_bucket.s3_bucket.bucket_domain_name
    origin_id   = aws_s3_bucket.s3_bucket.id
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_oac.id
  }

  default_cache_behavior {
    compress = true
    viewer_protocol_policy = "allow-all"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"] # ?
    cached_methods   = ["GET", "HEAD"]
    cache_policy_id  = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    target_origin_id = aws_s3_bucket.s3_bucket.id # ?
  }

	price_class = "PriceClass_200"

	viewer_certificate {
    cloudfront_default_certificate = true
  }
  enabled             = true # ?
  is_ipv6_enabled     = true

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["KR"]
    }
  }
}

resource "aws_cloudfront_origin_access_control" "cloudfront_oac" {
  name                              = aws_s3_bucket.s3_bucket.id
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = [
          aws_s3_bucket.s3_bucket.arn,
          "${aws_s3_bucket.s3_bucket.arn}/*"
				]
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cloudfront.arn
          }
        }
      }#,
      #{
      #  Sid       = "Access-to-specific-VPCE-only"
      #  Effect    = "Deny"
      #  Principal = "*"
      #  Action    = "s3:*"
      #  Resource = [
      #    aws_s3_bucket.s3_bucket.arn,
      #    "${aws_s3_bucket.s3_bucket.arn}/*"
      #  ]
      #  Condition = {
      #    StringNotEquals = {
      #      # "aws:ResourceAccount" = "1234512345"
      #      "aws:sourceVpce"      = aws_vpc_endpoint.s3_endpoint.id
      #    }
      #  }
      #}
    ]
  })
}
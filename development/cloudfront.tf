/**
 * Access Identity for assets
 */
resource "aws_cloudfront_origin_access_identity" "assets_origin_access_identity" {
  comment = "origin access identity for asset files (${var.environment})"
}

/**
 * CloudFront distribution for Assets
 */
resource "aws_cloudfront_distribution" "assets" {
  origin {
    domain_name = "${var.project}.${var.environment}.assets.s3.amazonaws.com"
    origin_id   = "${var.project}_${var.environment}_assets"
    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.assets_origin_access_identity.cloudfront_access_identity_path}"
    }
  }
  enabled = true
  comment = "For Candee Assets (${var.environment})"
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  default_cache_behavior {
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.project}_${var.environment}_assets"
    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

  }
}

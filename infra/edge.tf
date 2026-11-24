resource "aws_lb_listener" "https" {
  protocol   = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
}

resource "aws_cloudfront_distribution" "cdn" {
  viewer_certificate {
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

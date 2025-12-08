resource "aws_route53_zone" "https_cio_gov_zone" {
  name = "https.cio.gov."

  tags = {
    Project = "dns"
    client  = "OGP-20150420-20150930-01"
  }
}

resource "aws_route53_record" "https_cio_gov_https_cio_gov_a" {
  zone_id = aws_route53_zone.https_cio_gov_zone.zone_id
  name    = "https.cio.gov."
  type    = "A"

  alias {
    name                   = "d2h7trd5jt3vay.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

output "https_cio_gov_ns" {
  value = aws_route53_zone.https_cio_gov_zone.name_servers
}

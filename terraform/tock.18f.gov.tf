resource "aws_route53_record" "tock_18f_gov_acmechallenge" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.tock.18f.gov."
  type    = "CNAME"

  ttl     = 600
  records = ["_acme-challenge.tock.18f.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "d_18f_gov_tock_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "tock.18f.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["tock.18f.gov.external-domains-production.cloud.gov."]
}

// Commented out to maintain compatibility with commented out 18f.gov.tf zone definition

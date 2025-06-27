resource "aws_route53_zone" "kids_gov_zone" {
  name = "kids.gov"

  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "kids_gov_apex" {
  zone_id = aws_route53_zone.kids_gov_zone.zone_id
  name    = "kids.gov."
  type    = "A"
  alias {
    name                   = "d22hqkwn3m8vnt.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "kids_gov_apex_aaaa" {
  zone_id = aws_route53_zone.kids_gov_zone.zone_id
  name    = "kids.gov."
  type    = "AAAA"
  alias {
    name                   = "d22hqkwn3m8vnt.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "kids_gov_acmechallenge" {
  zone_id = aws_route53_zone.kids_gov_zone.zone_id
  name    = "_acme-challenge.kids.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.kids.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "kids_gov_www_acmechallenge" {
  zone_id = aws_route53_zone.kids_gov_zone.zone_id
  name    = "_acme-challenge.www.kids.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.www.kids.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "kids_gov_www" {
  zone_id = aws_route53_zone.kids_gov_zone.zone_id
  name    = "www.kids.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["www.kids.gov.external-domains-production.cloud.gov."]
}

module "kids_gov_emailsecurity" {
  source = "./email_security"

  zone_id = aws_route53_zone.kids_gov_zone.zone_id
  txt_records = ["v=spf1 -all"]
}

output "kids_gov_ns" {
  value = aws_route53_zone.kids_gov_zone.name_servers
}
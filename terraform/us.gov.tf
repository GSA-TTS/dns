resource "aws_route53_zone" "us_gov_zone" {
  name = "us.gov"

  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "us_gov_apex" {
  zone_id = aws_route53_zone.us_gov_zone.zone_id
  name    = "us.gov."
  type    = "A"
  alias {
    name                   = "d3uwdd7ah1501e.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "us_gov_apex_aaaa" {
  zone_id = aws_route53_zone.us_gov_zone.zone_id
  name    = "us.gov."
  type    = "AAAA"
  alias {
    name                   = "d3uwdd7ah1501e.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "us_gov_acmechallenge" {
  zone_id = aws_route53_zone.us_gov_zone.zone_id
  name    = "_acme-challenge.us.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.us.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "us_gov_www_acmechallenge" {
  zone_id = aws_route53_zone.us_gov_zone.zone_id
  name    = "_acme-challenge.www.us.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.www.us.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "us_gov_www" {
  zone_id = aws_route53_zone.us_gov_zone.zone_id
  name    = "www.us.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["www.us.gov.external-domains-production.cloud.gov."]
}

module "us_gov_emailsecurity" {
  source = "./email_security"

  zone_id = aws_route53_zone.us_gov_zone.zone_id
  txt_records = ["v=spf1 -all"]
}

output "us_gov_ns" {
  value = aws_route53_zone.us_gov_zone.name_servers
}
resource "aws_route53_zone" "benefits_gov_zone" {
  name = "benefits.gov"

  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "benefits_gov_apex" {
  zone_id = aws_route53_zone.benefits_gov_zone.zone_id
  name    = "benefits.gov."
  type    = "A"
  alias {
    name                   = "d3bi0ia5r11uox.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "benefits_gov_apex_aaaa" {
  zone_id = aws_route53_zone.benefits_gov_zone.zone_id
  name    = "benefits.gov."
  type    = "AAAA"
  alias {
    name                   = "d3bi0ia5r11uox.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "benefits_gov_acmechallenge" {
  zone_id = aws_route53_zone.benefits_gov_zone.zone_id
  name    = "_acme-challenge.benefits.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.benefits.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "benefits_gov_www_acmechallenge" {
  zone_id = aws_route53_zone.benefits_gov_zone.zone_id
  name    = "_acme-challenge.www.benefits.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.www.benefits.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "benefits_gov_ssabest_acmechallenge" {
  zone_id = aws_route53_zone.benefits_gov_zone.zone_id
  name    = "_acme-challenge.ssabest.benefits.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.ssabest.benefits.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "benefits_gov_ssabest" {
  zone_id = aws_route53_zone.benefits_gov_zone.zone_id
  name    = "ssabest.benefits.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["ssabest.benefits.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "benefits_gov_www" {
  zone_id = aws_route53_zone.benefits_gov_zone.zone_id
  name    = "www.benefits.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["www.benefits.gov.external-domains-production.cloud.gov."]
}

module "benefits_gov_emailsecurity" {
  source = "./email_security"

  zone_id     = aws_route53_zone.benefits_gov_zone.zone_id
  txt_records = ["v=spf1 -all"]
}

output "benefits_gov_ns" {
  value = aws_route53_zone.benefits_gov_zone.name_servers
}

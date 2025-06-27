resource "aws_route53_zone" "info_gov_zone" {
  name = "info.gov"

  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "info_gov_apex" {
  zone_id = aws_route53_zone.info_gov_zone.zone_id
  name    = "info.gov."
  type    = "A"
  alias {
    name                   = "dmqsrl2l7d7k2.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "info_gov_apex_aaaa" {
  zone_id = aws_route53_zone.info_gov_zone.zone_id
  name    = "info.gov."
  type    = "AAAA"
  alias {
    name                   = "dmqsrl2l7d7k2.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "info_gov_acmechallenge" {
  zone_id = aws_route53_zone.info_gov_zone.zone_id
  name    = "_acme-challenge.info.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.info.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "info_gov_www_acmechallenge" {
  zone_id = aws_route53_zone.info_gov_zone.zone_id
  name    = "_acme-challenge.www.info.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.www.info.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "info_gov_www" {
  zone_id = aws_route53_zone.info_gov_zone.zone_id
  name    = "www.info.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["www.info.gov.external-domains-production.cloud.gov."]
}

module "info_gov_emailsecurity" {
  source = "./email_security"

  zone_id = aws_route53_zone.info_gov_zone.zone_id
  txt_records = ["v=spf1 -all"]
}

output "info_gov_ns" {
  value = aws_route53_zone.info_gov_zone.name_servers
}
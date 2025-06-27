resource "aws_route53_zone" "firstgov_gov_zone" {
  name = "firstgov.gov"

  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "firstgov_gov_apex" {
  zone_id = aws_route53_zone.firstgov_gov_zone.zone_id
  name    = "firstgov.gov."
  type    = "A"
  alias {
    name                   = "d1x97bzkg8ze9.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "firstgov_gov_apex_aaaa" {
  zone_id = aws_route53_zone.firstgov_gov_zone.zone_id
  name    = "firstgov.gov."
  type    = "AAAA"
  alias {
    name                   = "d1x97bzkg8ze9.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "firstgov_gov_acmechallenge" {
  zone_id = aws_route53_zone.firstgov_gov_zone.zone_id
  name    = "_acme-challenge.firstgov.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.firstgov.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "firstgov_gov_www_acmechallenge" {
  zone_id = aws_route53_zone.firstgov_gov_zone.zone_id
  name    = "_acme-challenge.www.firstgov.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.www.firstgov.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "firstgov_gov_www" {
  zone_id = aws_route53_zone.firstgov_gov_zone.zone_id
  name    = "www.firstgov.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["www.firstgov.gov.external-domains-production.cloud.gov."]
}

module "firstgov_gov_emailsecurity" {
  source = "./email_security"

  zone_id = aws_route53_zone.firstgov_gov_zone.zone_id
  txt_records = ["v=spf1 -all"]
}

output "firstgov_gov_ns" {
  value = aws_route53_zone.firstgov_gov_zone.name_servers
}
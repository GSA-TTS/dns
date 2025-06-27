resource "aws_route53_zone" "usagov_gov_zone" {
  name = "usagov.gov"

  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "usagov_gov_apex" {
  zone_id = aws_route53_zone.usagov_gov_zone.zone_id
  name    = "usagov.gov."
  type    = "A"
  alias {
    name                   = "d17uso7tq128sd.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "usagov_gov_apex_aaaa" {
  zone_id = aws_route53_zone.usagov_gov_zone.zone_id
  name    = "usagov.gov."
  type    = "AAAA"
  alias {
    name                   = "d17uso7tq128sd.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "usagov_gov_acmechallenge" {
  zone_id = aws_route53_zone.usagov_gov_zone.zone_id
  name    = "_acme-challenge.usagov.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.usagov.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "usagov_gov_www_acmechallenge" {
  zone_id = aws_route53_zone.usagov_gov_zone.zone_id
  name    = "_acme-challenge.www.usagov.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.www.usagov.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "usagov_gov_www" {
  zone_id = aws_route53_zone.usagov_gov_zone.zone_id
  name    = "www.usagov.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["www.usagov.gov.external-domains-production.cloud.gov."]
}

module "usagov_gov_emailsecurity" {
  source = "./email_security"

  zone_id = aws_route53_zone.usagov_gov_zone.zone_id
  txt_records = ["v=spf1 -all"]
}

output "usagov_gov_ns" {
  value = aws_route53_zone.usagov_gov_zone.name_servers
}
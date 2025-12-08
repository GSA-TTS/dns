resource "aws_route53_zone" "govloans_gov_zone" {
  name = "govloans.gov"

  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "govloans_gov_apex" {
  zone_id = aws_route53_zone.govloans_gov_zone.zone_id
  name    = "govloans.gov."
  type    = "A"
  alias {
    name                   = "d2pvs1juwa2drp.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "govloans_gov_apex_aaaa" {
  zone_id = aws_route53_zone.govloans_gov_zone.zone_id
  name    = "govloans.gov."
  type    = "AAAA"
  alias {
    name                   = "d2pvs1juwa2drp.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "govloans_gov_acmechallenge" {
  zone_id = aws_route53_zone.govloans_gov_zone.zone_id
  name    = "_acme-challenge.govloans.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.govloans.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "govloans_gov_www_acmechallenge" {
  zone_id = aws_route53_zone.govloans_gov_zone.zone_id
  name    = "_acme-challenge.www.govloans.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.www.govloans.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "govloans_gov_www" {
  zone_id = aws_route53_zone.govloans_gov_zone.zone_id
  name    = "www.govloans.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["www.govloans.gov.external-domains-production.cloud.gov."]
}

module "govloans_gov_emailsecurity" {
  source = "./email_security"

  zone_id     = aws_route53_zone.govloans_gov_zone.zone_id
  txt_records = ["v=spf1 -all"]
}

output "govloans_gov_ns" {
  value = aws_route53_zone.govloans_gov_zone.name_servers
}

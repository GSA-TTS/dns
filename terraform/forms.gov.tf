resource "aws_route53_zone" "forms_gov_zone" {
  name = "forms.gov"

  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "forms_gov_apex" {
  zone_id = aws_route53_zone.forms_gov_zone.zone_id
  name    = "forms.gov."
  type    = "A"
  alias {
    name                   = "d1dhvsfal2z439.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "forms_gov_apex_aaaa" {
  zone_id = aws_route53_zone.forms_gov_zone.zone_id
  name    = "forms.gov."
  type    = "AAAA"
  alias {
    name                   = "d1dhvsfal2z439.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "forms_gov_acmechallenge" {
  zone_id = aws_route53_zone.forms_gov_zone.zone_id
  name    = "_acme-challenge.forms.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.forms.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "forms_gov_www_acmechallenge" {
  zone_id = aws_route53_zone.forms_gov_zone.zone_id
  name    = "_acme-challenge.www.forms.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.www.forms.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "forms_gov_www" {
  zone_id = aws_route53_zone.forms_gov_zone.zone_id
  name    = "www.forms.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["www.forms.gov.external-domains-production.cloud.gov."]
}

module "forms_gov_emailsecurity" {
  source = "./email_security"

  zone_id = aws_route53_zone.forms_gov_zone.zone_id
  txt_records = ["v=spf1 -all"]
}

output "forms_gov_ns" {
  value = aws_route53_zone.forms_gov_zone.name_servers
}
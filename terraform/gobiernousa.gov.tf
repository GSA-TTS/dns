resource "aws_route53_zone" "gobiernousa_gov_zone" {
  name = "gobiernousa.gov"

  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "gobiernousa_gov_apex" {
  zone_id = aws_route53_zone.gobiernousa_gov_zone.zone_id
  name    = "gobiernousa.gov."
  type    = "A"
  alias {
    name                   = "d3ol7qo67uft5m.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "gobiernousa_gov_apex_aaaa" {
  zone_id = aws_route53_zone.gobiernousa_gov_zone.zone_id
  name    = "gobiernousa.gov."
  type    = "AAAA"
  alias {
    name                   = "d3ol7qo67uft5m.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "gobiernousa_gov_acmechallenge" {
  zone_id = aws_route53_zone.gobiernousa_gov_zone.zone_id
  name    = "_acme-challenge.gobiernousa.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.gobiernousa.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "gobiernousa_gov_www_acmechallenge" {
  zone_id = aws_route53_zone.gobiernousa_gov_zone.zone_id
  name    = "_acme-challenge.www.gobiernousa.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.www.gobiernousa.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "gobiernousa_gov_www" {
  zone_id = aws_route53_zone.gobiernousa_gov_zone.zone_id
  name    = "www.gobiernousa.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["www.gobiernousa.gov.external-domains-production.cloud.gov."]
}

module "gobiernousa_gov_emailsecurity" {
  source = "./email_security"

  zone_id = aws_route53_zone.gobiernousa_gov_zone.zone_id
  txt_records = ["v=spf1 -all"]
}

output "gobiernousa_gov_ns" {
  value = aws_route53_zone.gobiernousa_gov_zone.name_servers
}
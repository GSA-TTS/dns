resource "aws_route53_zone" "consumeraction_gov_zone" {
  name = "consumeraction.gov"

  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "consumeraction_gov_apex" {
  zone_id = aws_route53_zone.consumeraction_gov_zone.zone_id
  name    = "consumeraction.gov."
  type    = "A"
  alias {
    name                   = "d2pa8dkybxxcna.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "consumeraction_gov_apex_aaaa" {
  zone_id = aws_route53_zone.consumeraction_gov_zone.zone_id
  name    = "consumeraction.gov."
  type    = "AAAA"
  alias {
    name                   = "d2pa8dkybxxcna.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "consumeraction_gov_acmechallenge" {
  zone_id = aws_route53_zone.consumeraction_gov_zone.zone_id
  name    = "_acme-challenge.consumeraction.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.consumeraction.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "consumeraction_gov_www_acmechallenge" {
  zone_id = aws_route53_zone.consumeraction_gov_zone.zone_id
  name    = "_acme-challenge.www.consumeraction.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.www.consumeraction.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "consumeraction_gov_www" {
  zone_id = aws_route53_zone.consumeraction_gov_zone.zone_id
  name    = "www.consumeraction.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["www.consumeraction.gov.external-domains-production.cloud.gov."]
}

module "consumeraction_gov_emailsecurity" {
  source = "./email_security"

  zone_id = aws_route53_zone.consumeraction_gov_zone.zone_id
  txt_records = ["v=spf1 -all"]
}

output "consumeraction_gov_ns" {
  value = aws_route53_zone.consumeraction_gov_zone.name_servers
}
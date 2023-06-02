resource "aws_route53_zone" "fac_gov_zone" {
  name = "fac.gov."

  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "fac_gov_fac_gov_a" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "fac.gov."
  type    = "A"

  alias {
    name                   = "d3bkpuj8pzucbe.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "fac_gov_fac_gov_aaaa" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "fac.gov."
  type    = "AAAA"

  alias {
    name                   = "d3bkpuj8pzucbe.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "fac_gov__acme_challenge_fac_gov_cname" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "_acme-challenge.fac.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["_acme-challenge.fac.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "fac_gov__www_fac_gov_cname" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "www.fac.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["www.fac.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "fac_gov__acme_challenge_www_fac_cname" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "_acme-challenge.www.fac.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["_acme-challenge.www.fac.gov.external-domains-production.cloud.gov."]
}

module "fac_gov__email_security" {
  source = "./email_security"

  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  txt_records = [
    "v=spf1 include:_spf.google.com ~all",
    "google-site-verification=Mn_07QfFVDwIFVW5EYimMZZK_kqYdFX9EtHjlpIX_-c",
  ]
}

resource "aws_route53_record" "fac_gov__mx" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "fac.gov."
  type    = "MX"
  ttl     = 60
  records = [
    "1 aspmx.l.google.com.", 
    "5 alt1.aspmx.l.google.com.", 
    "5 alt2.aspmx.l.google.com.",
    "10 alt3.aspmx.l.google.com.", 
    "10 alt4.aspmx.l.google.com.", 
  ]
}

output "fac_gov_ns" {
  value = aws_route53_zone.fac_gov_zone.name_servers
}

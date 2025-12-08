resource "aws_route53_zone" "fac_gov_zone" {
  name = "fac.gov."

  tags = {
    Project = "dns"
  }
}


# ACME challege for fac.gov
resource "aws_route53_record" "fac_gov__acme_challenge_fac_gov_cname" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "_acme-challenge.fac.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["_acme-challenge.fac.gov.external-domains-production.cloud.gov."]
}

# A record for fac.gov
resource "aws_route53_record" "fac_gov_fac_gov_a" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "fac.gov."
  type    = "A"

  alias {
    name                   = "d3bkpuj8pzucbe.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

# AAAA for fac.gov
resource "aws_route53_record" "fac_gov_fac_gov_aaaa" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "fac.gov."
  type    = "AAAA"

  alias {
    name                   = "d3bkpuj8pzucbe.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

# ACME challege for www.fac.gov
resource "aws_route53_record" "fac_gov__acme_challenge_www_fac_cname" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "_acme-challenge.www.fac.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["_acme-challenge.www.fac.gov.external-domains-production.cloud.gov."]
}

# CNAME for www.fac.gov
resource "aws_route53_record" "fac_gov__www_fac_gov_cname" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "www.fac.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["www.fac.gov.external-domains-production.cloud.gov."]
}

# ACME challege for app.fac.gov
resource "aws_route53_record" "fac_gov__acme_challenge_app_fac_gov_cname" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "_acme-challenge.app.fac.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["_acme-challenge.app.fac.gov.external-domains-production.cloud.gov."]
}

# CNAME for app.fac.gov
resource "aws_route53_record" "fac_gov__app_fac_gov_cname" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "app.fac.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["app.fac.gov.external-domains-production.cloud.gov."]
}

# ACME challenge for api.fac.gov
resource "aws_route53_record" "fac_gov__api_fac_gov_acme" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "_acme-challenge.api.fac.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["_acme-challenge-api-fac-gov.domains.api.data.gov"]
}

# CNAME for api.fac.gov
resource "aws_route53_record" "fac_gov__api_fac_gov_cname" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "api.fac.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["api-fac-gov.domains.api.data.gov"]
}

# ACME challenge for api-preview.fac.gov
resource "aws_route53_record" "fac_gov__api_preview_fac_gov_acme" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "_acme-challenge.api-preview.fac.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["_acme-challenge-api-preview-fac-gov.domains.api.data.gov"]
}

# CNAME for api-preview.fac.gov
resource "aws_route53_record" "fac_gov__api_preview_fac_gov_cname" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "api-preview.fac.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["api-preview-fac-gov.domains.api.data.gov"]
}

# ACME challenge for api-staging.fac.gov
resource "aws_route53_record" "fac_gov__api_staging_fac_gov_acme" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "_acme-challenge.api-staging.fac.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["_acme-challenge-api-staging-fac-gov.domains.api.data.gov"]
}

# CNAME for api-staging.fac.gov
resource "aws_route53_record" "fac_gov__api_staging_fac_gov_cname" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "api-staging.fac.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["api-staging-fac-gov.domains.api.data.gov"]
}

# ACME challenge for api-dev.fac.gov
resource "aws_route53_record" "fac_gov__api_dev_fac_gov_acme" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "_acme-challenge.api-dev.fac.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["_acme-challenge-api-dev-fac-gov.domains.api.data.gov"]
}

# CNAME for api-dev.fac.gov
resource "aws_route53_record" "fac_gov__api_dev_fac_gov_cname" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "api-dev.fac.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["api-dev-fac-gov.domains.api.data.gov"]
}

# SPF for mail from fac.gov
module "fac_gov__email_security" {
  source = "./email_security"

  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  txt_records = [
    "v=spf1 include:_spf.google.com ~all",
    "google-site-verification=Mn_07QfFVDwIFVW5EYimMZZK_kqYdFX9EtHjlpIX_-c",
  ]
}

# MX records for mail from fac.gov
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

# DKIM record for mail from fac.gov
resource "aws_route53_record" "fac_gov__dkim" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "google._domainkey.fac.gov."
  type    = "TXT"
  ttl     = 60
  records = [
    "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDaRrmLRMyVzod2xJGqfN7oMP4T4oNeQ6z53uyJUK76Hs5qUg7dQyNgVeMck18aRN0iuHPPqA+e5z3Lm564Sa2LtDbybA9Q6HuYidkeoFPHHzjRDf8GsXogpji8oIc5TIVv17KG8niWB0MPfZPb4WlhKiCfgkPUbyuL8Q3IRd3iFQIDAQAB",
  ]
}

# DMARC record for mail from fac.gov
resource "aws_route53_record" "fac_gov__dmarc" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "dmarc.fac.gov."
  type    = "TXT"
  ttl     = 300
  records = [
    "v=DMARC1; p=reject; pct=100; fo=1; ri=86400; rua=mailto:dmarcreports@gsa.gov,mailto:reports@dmarc.cyber.dhs.gov; ruf=mailto:dmarcfailures@gsa.gov",
  ]
}

# CNAME for support.fac.gov via ZenDesk
resource "aws_route53_record" "fac_gov__support_fac_gov_cname" {
  zone_id = aws_route53_zone.fac_gov_zone.zone_id
  name    = "support.fac.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["fac-gov.zendesk.com."]
}

output "fac_gov_ns" {
  value = aws_route53_zone.fac_gov_zone.name_servers
}

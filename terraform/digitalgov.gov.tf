# These DNS records are hosted out of Route53, and managed by Digital.gov and the Infrastructure team at Technology Transformation Services (TTS).
# More information on editing: https://github.com/18F/dns/blob/main/README.md
# To request a change, file an issue: https://github.com/18F/dns
# Question? email digitalgov@gsa.gov or reach us in #digitalgov in Slack

# =================================

# For each record, please leave:
# - primary contact information
# - comments explaining what the record is used for, or where it redirects

# NOTE: digitalgov.gov is a legacy domain that is still hooked up to a number of services in TTS. See the Digital.gov file for more additional records https://github.com/18F/dns/blob/main/terraform/digital.gov.tf

# =================================

# INIT

resource "aws_route53_zone" "digitalgov_gov_zone" {
  name = "digitalgov.gov."
  tags = {
    Project = "dns"
  }
}

# =================================

# REDIRECTS

# Most of our redirects go through an app called pages_redirect, managed by the Federalist team
# To file a new redirect, create an issue at https://github.com/18F/pages-redirects

# digitalgov.gov
# Redirects to digital.gov through pages_redirect
resource "aws_route53_record" "digitalgov_gov_apex" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "digitalgov.gov."
  type    = "A"
  alias {
    name                   = "dj62070yqrr60.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "digitalgov_gov_apex_aaaa" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "digitalgov.gov."
  type    = "AAAA"
  alias {
    name                   = "dj62070yqrr60.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

# www.digitalgov.gov — redirects to digital.gov through pages_redirect
resource "aws_route53_record" "digitalgov_gov_www" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "www.digitalgov.gov."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "d1rrea61xhwc36.cloudfront.net."
  ]
}

# OpenOpps
# openopps.digitalgov.gov — redirects to openopps.usajobs.gov through pages_redirect
resource "aws_route53_record" "digitalgov_gov_openopps_digitalgov_gov_a" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "openopps.digitalgov.gov."
  type    = "A"
  alias {
    name                   = "d198punmzgrl9l.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "digitalgov_gov_openopps_digitalgov_gov_aaaa" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "openopps.digitalgov.gov."
  type    = "AAAA"
  alias {
    name                   = "d198punmzgrl9l.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

# search.digitalgov.gov
resource "aws_route53_record" "search_digitalgov_gov_a" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "search.digitalgov.gov."
  type    = "CNAME"
  ttl     = "600"
  records = [
    "dgsearchsite.infr.search.usa.gov."
  ]
}

# summit.digitalgov.gov — redirects to digital.gov through pages_redirect
resource "aws_route53_record" "summit_digitalgov_gov_a" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "summit.digitalgov.gov."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "d3quko6qtudpnl.cloudfront.net."
  ]
}

# find.digitalgov.gov
# redirects to digital.gov — though unclear where the redirect is happening
resource "aws_route53_record" "find_digitalgov_gov_a" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "find.digitalgov.gov."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "digitalgov.sites.infr.search.usa.gov."
  ]
}

# END REDIRECTS

# =================================

# SERVICES

# Digital Analytics Program (DAP) —
# dap.digitalgov.gov
# reach out to dap@support.digitalgov.gov before making any changes
resource "aws_route53_record" "dap_digitalgov_gov_a" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "dap.digitalgov.gov."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "d27f3qgc9anoq2.cloudfront.net."
  ]
}

# DAP Temporary record for validation
resource "aws_route53_record" "dap_validation_digitalgov_gov_a" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "_c80f04313e7e2fadb177e34e2dedf0d6.dap.digitalgov.gov."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "_3f7fd3397174324e46798283045cd3e7.acm-validations.aws"
  ]
}

# END SERVICES

# =================================

# EMAIL and SUPPORT SERVICES

# o166.email.digitalgov.gov — A
# Unclear what this is for.
resource "aws_route53_record" "o166_email_digitalgov_gov_a" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "o166.email.digitalgov.gov."
  type    = "A"
  ttl     = "300"
  records = [
    "167.89.86.190"
  ]
}

# admin.digitalgov.gov — A
# Unclear what this is for.
resource "aws_route53_record" "admin_digitalgov_gov_a" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "admin.digitalgov.gov."
  type    = "A"
  ttl     = "600"
  records = [
    "173.203.40.168"
  ]
}

# support.digitalgov.gov — A
# used a number of teams across TTS in conjunction with Zendesk
# - USWDS
# - Search.gov
# - DAP
resource "aws_route53_record" "support_digitalgov_gov_a" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "support.digitalgov.gov."
  type    = "A"
  ttl     = "600"
  records = [
    "216.128.241.47",
    "173.252.148.104",
  ]
}

# required for AWS SES to DKIM-sign emails sent "From" support.digitalgov.gov
resource "aws_route53_record" "support_digitalgov_gov_ses_dkim_a" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "4ixtpnvpubjuxqvnex727otq55y2ew7w._domainkey.support.digitalgov.gov."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "4ixtpnvpubjuxqvnex727otq55y2ew7w.dkim.amazonses.com"
  ]
}

# required for AWS SES to DKIM-sign emails sent "From" support.digitalgov.gov
resource "aws_route53_record" "support_digitalgov_gov_ses_dkim_b" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "tmoxp5vgftwsmhkukt2z6ayvfj5bw7zo._domainkey.support.digitalgov.gov."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "tmoxp5vgftwsmhkukt2z6ayvfj5bw7zo.dkim.amazonses.com"
  ]
}

# required for AWS SES to DKIM-sign emails sent "From" support.digitalgov.gov
resource "aws_route53_record" "support_digitalgov_gov_ses_dkim_c" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "5uiojtkg7z5grkldq7ajm3zamtzh3h2s._domainkey.support.digitalgov.gov."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "5uiojtkg7z5grkldq7ajm3zamtzh3h2s.dkim.amazonses.com"
  ]
}

# required by AWS SES to verify control of the support.digitalgov.gov domain
resource "aws_route53_record" "support_digitalgov_gov_ses_verification" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "_amazonses.support.digitalgov.gov."
  type    = "TXT"
  ttl     = "3600"
  records = [
    "T5etn/YylzSUQQWw6HspyK4+2+B9XzE7Kajpz9ogfJI="
  ]
}

# support.digitalgov.gov - TXT
resource "aws_route53_record" "digitalgov_gov_support_digitalgov_gov_txt" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "support.digitalgov.gov."
  type    = "TXT"
  ttl     = "3600"
  records = [
    "v=spf1 mx a:spf.servicenowservices.com include:amazonses.com include:1962994.spf05.hubspotemail.net ~all"
  ]
}

# support.digitalgov.gov — MX
resource "aws_route53_record" "support_digitalgov_gov_mx" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "support.digitalgov.gov."
  type    = "MX"
  ttl     = "600"
  records = [
    "10 inbound-smtp.us-east-1.amazonaws.com."
  ]
}

# email.digitalgov.gov — MX
# unclear what this is for
resource "aws_route53_record" "email_digitalgov_gov_mx" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "email.digitalgov.gov."
  type    = "MX"
  ttl     = "3600"
  records = [
    "10 mx.sendgrid.net."
  ]
}

# email.digitalgov.gov - TXT
resource "aws_route53_record" "digitalgov_gov_email_digitalgov_gov_txt" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "email.digitalgov.gov."
  type    = "TXT"
  ttl     = "3600"
  records = [
    "v=spf1 ip4:167.89.86.190 -all"
  ]
}

# END EMAIL and SUPPORT SERVICES

# =================================

# EMAIL NEWSLETTER (HubSpot)

# connect.digitalgov.gov
# A former landing page for signing up for the HubSpot newsletter
# Needs to be removed and redirected to https://digital.gov
resource "aws_route53_record" "connect_digitalgov_gov_a" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "connect.digitalgov.gov."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "1962994g44.secure0082.hubspot.net."
  ]
}

# Hubspot records for sending email from the digitalgov.gov domain
# See https://knowledge.hubspot.com/email/can-i-use-a-dmarc-policy-with-hubspot#troubleshoot-issues-with-dmarc-authentication
resource "aws_route53_record" "hubspot1_digitalgov_gov_a" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "hs1._domainkey.digitalgov.gov."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "digitalgov-gov.hs01a.dkim.hubspotemail.net."
  ]
}

# Hubspot records for sending email from the digitalgov.gov domain
# See https://knowledge.hubspot.com/email/can-i-use-a-dmarc-policy-with-hubspot#troubleshoot-issues-with-dmarc-authentication
resource "aws_route53_record" "hubspot2_digitalgov_gov_a" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "hs2._domainkey.digitalgov.gov."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "digitalgov-gov.hs01b.dkim.hubspotemail.net."
  ]
}

# Hubspot records for sending email from the digitalgov.gov domain
# See https://knowledge.hubspot.com/email/can-i-use-a-dmarc-policy-with-hubspot#troubleshoot-issues-with-dmarc-authentication
resource "aws_route53_record" "hubspot3_digitalgov_gov_a" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "hs1-1962994._domainkey.support.digitalgov.gov."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "support-digitalgov-gov.hs11a.dkim.hubspotemail.net."
  ]
}

# Hubspot records for sending email from the digitalgov.gov domain
# See https://knowledge.hubspot.com/email/can-i-use-a-dmarc-policy-with-hubspot#troubleshoot-issues-with-dmarc-authentication
resource "aws_route53_record" "hubspot4_digitalgov_gov_a" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "hs2-1962994._domainkey.support.digitalgov.gov."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "support-digitalgov-gov.hs11b.dkim.hubspotemail.net."
  ]
}

# OLD Hubspot TXT records for sending email from the digitalgov.gov domain
# Need to verify with Hubspot that this can be removed
# m1._domainkey.digitalgov.gov - TXT
resource "aws_route53_record" "digitalgov_gov_m1_domainkey_digitalgov_gov_txt" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "m1._domainkey.digitalgov.gov."
  type    = "TXT"
  ttl     = "300"
  records = [
    "k=rsa; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC4CvMOSVFOQDIJ+HkjdfAmKuBkkiqTwV982PCFBocVGHY07N2uvkleqT+XrySENYYzFrdnk2U1I7HUYkA0tpEZNzU7G67l7u1qWcd5QMBzVDsAg2vJf4fAkAWmdQCyWboeVXCoMnswz5LZK/t0+Z37smv9k2nDK3XNdsYTVu8D8wIDAQAB"
  ]
}

# NEW Hubspot TXT records for sending email from the digitalgov.gov domain
resource "aws_route53_record" "hubspot_digitalgov_gov_txt" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "smtpapi._domainkey.digitalgov.gov."
  type    = "TXT"
  ttl     = "300"
  records = [
    "k=rsa; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDPtW5iwpXVPiH5FzJ7Nrl8USzuY9zqqzjE0D1r04xDN6qwziDnmgcFNNfMewVKN2D1O+2J9N14hRprzByFwfQW76yojh54Xu3uSbQ3JP0A7k8o8GutRF8zbFUA8n0ZH2y0cIEjMliXY4W4LwPA7m4q0ObmvSjhd63O9d8z1XkUBwIDAQAB"
  ]
}

# END EMAIL NEWSLETTER (HubSpot)

# =================================

# TXT RECORDS
# Unclear what these are connected to, or if they are needed any more

# dzc.digitalgov.gov - TXT
resource "aws_route53_record" "digitalgov_gov_dzc_digitalgov_gov_txt" {
  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  name    = "dzc.digitalgov.gov."
  type    = "TXT"
  ttl     = "300"
  records = [
    "8wtx7v9M"
  ]
}

# END TXT RECORDS

# =================================

# BOD / SECURITY RECORDS (DMARC, SPF, etc...)

module "digitalgov_gov__email_security" {
  source = "./email_security"

  zone_id = aws_route53_zone.digitalgov_gov_zone.zone_id
  txt_records = [
    "google-site-verification=WRPUo6XC7m4X-8jJFvXPVs-W4uiqfEbF-pQYcD1-MOU",
    local.spf_hubspot
  ]
}

# END BOD / SECURITY RECORDS (DMARC, SPF, etc...)

# =================================

# Output to Route53
output "digitalgov_gov_ns" {
  value = aws_route53_zone.digitalgov_gov_zone.name_servers
}

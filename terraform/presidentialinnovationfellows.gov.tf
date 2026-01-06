resource "aws_route53_zone" "presidentialinnovationfellows_toplevel" {
  name = "presidentialinnovationfellows.gov"

  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "presidentialinnovationfellows_www" {
  zone_id = aws_route53_zone.presidentialinnovationfellows_toplevel.zone_id
  name    = "www.presidentialinnovationfellows.gov."
  type    = "A"

  alias {
    name                   = "d26prp92rpqmzl.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "presidentialinnovationfellows_www_aaaa" {
  zone_id = aws_route53_zone.presidentialinnovationfellows_toplevel.zone_id
  name    = "www.presidentialinnovationfellows.gov."
  type    = "AAAA"

  alias {
    name                   = "d26prp92rpqmzl.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "presidentialinnovationfellows_www_acme_challenge" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "_acme-challenge.www.presidentialinnovationfellows.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["_acme-challenge.www.presidentialinnovationfellows.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "presidentialinnovationfellows_apex" {
  zone_id = aws_route53_zone.presidentialinnovationfellows_toplevel.zone_id
  name    = "presidentialinnovationfellows.gov."
  type    = "A"

  alias {
    name                   = "d26prp92rpqmzl.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "presidentialinnovationfellows_apex_aaaa" {
  zone_id = aws_route53_zone.presidentialinnovationfellows_toplevel.zone_id
  name    = "presidentialinnovationfellows.gov."
  type    = "AAAA"

  alias {
    name                   = "d26prp92rpqmzl.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "presidentialinnovationfellows_apex_acme_challenge" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "_acme-challenge.presidentialinnovationfellows.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["_acme-challenge.presidentialinnovationfellows.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "presidentialinnovationfellows_mx" {
  zone_id = aws_route53_zone.presidentialinnovationfellows_toplevel.zone_id
  name    = "presidentialinnovationfellows.gov."
  type    = "MX"
  ttl     = 60
  records = ["10 alt3.aspmx.l.google.com.", "10 alt4.aspmx.l.google.com.", "1 aspmx.l.google.com.", "5 alt1.aspmx.l.google.com.", "5 alt2.aspmx.l.google.com."]
}

module "presidentialinnovationfellows_gov__email_security" {
  source = "./email_security"

  zone_id = aws_route53_zone.presidentialinnovationfellows_toplevel.zone_id
  txt_records = [
    local.spf_no_mail,
    "google-site-verification=RBhAMKMQvrHWfxNfosQ9oUrrcwAme78JlrhD3cTQCvY"
  ]
}

resource "aws_route53_record" "presidentialinnovationfellows_gov__github-challenge-presidential-innovation-fellows_presidentialinnovationfellows_gov_txt" {
  zone_id = aws_route53_zone.presidentialinnovationfellows_toplevel.zone_id
  name    = "_github-challenge-presidential-innovation-fellows.pif.gov."
  type    = "TXT"
  ttl     = 60
  records = ["128bd6e5cf"]
}

resource "aws_route53_record" "presidentialinnovationfellows_amazonses" {
  zone_id = aws_route53_zone.presidentialinnovationfellows_toplevel.zone_id
  name    = "_amazonses.presidentialinnovationfellows.gov."
  type    = "TXT"
  ttl     = 1800
  records = ["7q2e04OSN64Ey2OfWI9cHmvQ3ZmG3c/u+N8BzZtxMgU="]
}

resource "aws_route53_record" "presidentialinnovationfellows_domainkey_1" {
  zone_id = aws_route53_zone.presidentialinnovationfellows_toplevel.zone_id
  name    = "7fz4jdqdwujjhu2p2kk7az3ttz7amtql._domainkey.presidentialinnovationfellows.gov."
  type    = "CNAME"
  ttl     = 1800
  records = ["7fz4jdqdwujjhu2p2kk7az3ttz7amtql.dkim.amazonses.com"]
}

resource "aws_route53_record" "presidentialinnovationfellows_domainkey_2" {
  zone_id = aws_route53_zone.presidentialinnovationfellows_toplevel.zone_id
  name    = "jqewov2ncvy7kbnvsphmkpuhsrrdxgpi._domainkey.presidentialinnovationfellows.gov."
  type    = "CNAME"
  ttl     = 1800
  records = ["jqewov2ncvy7kbnvsphmkpuhsrrdxgpi.dkim.amazonses.com"]
}

resource "aws_route53_record" "presidentialinnovationfellows_domainkey_3" {
  zone_id = aws_route53_zone.presidentialinnovationfellows_toplevel.zone_id
  name    = "xj5lii5m5qopbxzuxy4fblxbgbf2cq3e._domainkey.presidentialinnovationfellows.gov."
  type    = "CNAME"
  ttl     = 1800
  records = ["xj5lii5m5qopbxzuxy4fblxbgbf2cq3e.dkim.amazonses.com"]
}

resource "aws_route53_record" "presidentialinnovationfellows_domainkey_4" {
  zone_id = aws_route53_zone.presidentialinnovationfellows_toplevel.zone_id
  name    = "cbc8cc32be1472b484a33c816d5e1ea4.presidentialinnovationfellows.gov."
  type    = "CNAME"
  ttl     = 1800
  records = ["a1f5db99eecd3aea9859248b9db2008152818166.comodoca.com."]
}

output "presidentialinnovationfellows_ns" {
  value = aws_route53_zone.presidentialinnovationfellows_toplevel.name_servers
}

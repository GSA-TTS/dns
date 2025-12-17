resource "aws_route53_zone" "pif_toplevel" {
  name = "pif.gov"

  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "pif.gov."
  type    = "A"

  alias {
    name                   = "dgevgiwb7xxpw.cloudfront.net"
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_aaaa" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "pif.gov."
  type    = "AAAA"

  alias {
    name                   = "dgevgiwb7xxpw.cloudfront.net"
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "mx" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "pif.gov."
  type    = "MX"
  ttl     = 60
  records = ["10 alt3.aspmx.l.google.com.", "10 alt4.aspmx.l.google.com.", "1 aspmx.l.google.com.", "5 alt1.aspmx.l.google.com.", "5 alt2.aspmx.l.google.com."]
}

module "pif_gov__email_security" {
  source = "./email_security"

  zone_id     = aws_route53_zone.pif_toplevel.zone_id
  txt_records = ["v=spf1 include:gsa.gov ~all"]
}

resource "aws_route53_record" "pif_gov_domainkey_pif_gov_txt" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "google._domainkey.pif.gov"
  type    = "TXT"
  ttl     = "300"
  records = [
    "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsaAjhxSW+z1C0s3e+t1ieRB0VrUGKHMTcENFdoVs6hnUMgMNXpX3EGo61TXHRBghX6bP1aoNN8TjouUB1/HNUqA7i0gCEQwN12O67+gKl5qy6poLroTs9pBVsKr\"\"iDHbCR0y9hzE8zuboOVerR+J7cnpwvm/GhNf3TBDU8MojtwM4DEzHYrpe/qMNYAnQp7G5kfTpqq2pyZMzu+O7c1/E8WF/PjEyeAm1dtqnLeCmCcXP3Z3YMRe5VC8++GPdUsnxxggDgh8WQ6TBKWMLx0FZbKswIphIo/Xq3CNsscqhC7rTUljiZzbEKEs17NRPjO70p44k5q1lJE686f4eZ9X6pwIDAQAB"
  ]
}

resource "aws_route53_record" "paygap_slack_cname" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "paygap-slack.pif.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["d1h4sxl9j1vd6e.cloudfront.net"]
}

resource "aws_route53_record" "amazonses_txt" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "_amazonses.pif.gov."
  type    = "TXT"
  ttl     = 60
  records = ["vfTT1hoRSwsfsjE7oHkyOB2+OHk+t2NF3S3l5hL4NA8="]
}

resource "aws_route53_record" "pif_gov__github-challenge-presidential-innovation-fellows_pif_gov_txt" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "_github-challenge-presidential-innovation-fellows.pif.gov."
  type    = "TXT"
  ttl     = 60
  records = ["468cca22d9"]
}

resource "aws_route53_record" "ses_cname_1" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "hqxmpb4wvicc7sgousvwutczjusp4sfc._domainkey.pif.gov."
  type    = "CNAME"
  ttl     = 1800
  records = ["hqxmpb4wvicc7sgousvwutczjusp4sfc.dkim.amazonses.com"]
}

resource "aws_route53_record" "ses_cname_2" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "nv3r33tblbqana3lj5a5x4bzq4gxcetz._domainkey.pif.gov."
  type    = "CNAME"
  ttl     = 1800
  records = ["nv3r33tblbqana3lj5a5x4bzq4gxcetz.dkim.amazonses.com"]
}

resource "aws_route53_record" "ses_cname_3" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "zozbm3olsvjtarcghhuz2sneknw7ar5t._domainkey.pif.gov."
  type    = "CNAME"
  ttl     = 1800
  records = ["zozbm3olsvjtarcghhuz2sneknw7ar5t.dkim.amazonses.com"]
}

resource "aws_route53_record" "proposal_cname" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "proposal.pif.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["proposal.pif.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "proposal_acme_challenge" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "_acme-challenge.proposal.pif.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.proposal.pif.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "d_pif_gov__acme_challenge_paygap_pif_cname" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "_acme-challenge.paygap.pif.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.paygap.pif.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "paygap_pif_cname" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "paygap.pif.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["paygap.pif.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "d_pif_gov__acme_challenge_tophealth_pif_cname" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "_acme-challenge.tophealth.pif.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.tophealth.pif.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "tophealth_pif_cname" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "tophealth.pif.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["tophealth.pif.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "review_cname" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "review.pif.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["review.pif.gov.00d30000000jvliea4.live.siteforce.com"]
}

resource "aws_route53_record" "www-main" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "www.pif.gov."
  type    = "A"

  alias {
    name                   = "dgevgiwb7xxpw.cloudfront.net"
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www-main_aaaa" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "www.pif.gov."
  type    = "AAAA"

  alias {
    name                   = "dgevgiwb7xxpw.cloudfront.net"
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "apply_pif_cname" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "apply.pif.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["apply.pif.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "apply_pif_acme_challenge" {
  zone_id = aws_route53_zone.pif_toplevel.zone_id
  name    = "_acme-challenge.apply.pif.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.apply.pif.gov.external-domains-production.cloud.gov."]
}

output "pif_ns" {
  value = aws_route53_zone.pif_toplevel.name_servers
}

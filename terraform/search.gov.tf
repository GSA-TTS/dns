resource "aws_route53_zone" "search_toplevel" {
  name = "search.gov"

  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "search_gov_apex" {
  zone_id = aws_route53_zone.search_toplevel.zone_id
  name    = "search.gov."
  type    = "A"

  alias {
    name                   = "d3b0ro7nh4961l.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "search_gov_apex_aaaa" {
  zone_id = aws_route53_zone.search_toplevel.zone_id
  name    = "search.gov."
  type    = "AAAA"

  alias {
    name                   = "d3b0ro7nh4961l.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "search_gov_www_cname" {
  zone_id = aws_route53_zone.search_toplevel.zone_id
  name    = "www.search.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["www.search.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "search_gov_acme_challenge" {
  zone_id = aws_route53_zone.search_toplevel.zone_id
  name    = "_acme-challenge.search.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.search.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "www_search_gov_acme_challenge" {
  zone_id = aws_route53_zone.search_toplevel.zone_id
  name    = "_acme-challenge.www.search.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.www.search.gov.external-domains-production.cloud.gov."]
}


## TEMPORARY for validation of planned hosting setup 2025-08-08
resource "aws_route53_record" "whtnfrvemzeq_search_gov_acme_challenge" {
  zone_id = aws_route53_zone.search_toplevel.zone_id
  name    = "_acme-challenge.whtnfrvemzeq.search.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.whtnfrvemzeq.search.gov.external-domains-production.cloud.gov."]
}

## TEMPORARY for validation of planned hosting setup 2025-08-08
resource "aws_route53_record" "search_gov_whtnfrvemzeq" {
  zone_id = aws_route53_zone.search_toplevel.zone_id
  name    = "whtnfrvemzeq.search.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["whtnfrvemzeq.search.gov.external-domains-production.cloud.gov."]
}

# find.search.gov
resource "aws_route53_record" "search_gov_find" {
  zone_id = aws_route53_zone.search_toplevel.zone_id
  name    = "find.search.gov."
  type    = "CNAME"
  ttl     = 5
  records = ["search.usa.gov."]
}

# admin-center-downtime.search.gov
resource "aws_route53_record" "search_gov_downtime" {
  zone_id = aws_route53_zone.search_toplevel.zone_id
  name    = "admin-center-downtime.search.gov."
  type    = "CNAME"
  records = ["admin-center-downtime.search.usa.gov."]
  ttl     = "300"
}

# Email
resource "aws_route53_record" "search_gov_mx" {
  zone_id = aws_route53_zone.search_toplevel.zone_id
  name    = "search.gov."
  type    = "MX"
  ttl     = 300
  records = ["10 inbound-smtp.us-east-1.amazonaws.com."]
}

resource "aws_route53_record" "search_gov__amazonses_search_gov_txt" {
  zone_id = aws_route53_zone.search_toplevel.zone_id
  name    = "_amazonses.search.gov."
  type    = "TXT"
  ttl     = 300
  records = ["bhZh0ZXP7e8vJ1zeTFVBUn/n1rE5NHWBzOIgVG71swI="]
}

# Proof of ownership over the domain for DKIM
resource "aws_route53_record" "search_gov_ses_cname_1" {
  zone_id = aws_route53_zone.search_toplevel.zone_id
  name    = "xwqqkvd3oiguazj5xtri4l2quk2slsjr._domainkey.search.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["xwqqkvd3oiguazj5xtri4l2quk2slsjr.dkim.amazonses.com"]
}

resource "aws_route53_record" "search_gov_ses_cname_2" {
  zone_id = aws_route53_zone.search_toplevel.zone_id
  name    = "e6bt5rkriehhccrznsjdtdftttuzacn7._domainkey.search.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["e6bt5rkriehhccrznsjdtdftttuzacn7.dkim.amazonses.com"]
}

resource "aws_route53_record" "search_gov_ses_cname_3" {
  zone_id = aws_route53_zone.search_toplevel.zone_id
  name    = "476wutugvn6kvv42jtwtgaggzogsyvje._domainkey.search.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["476wutugvn6kvv42jtwtgaggzogsyvje.dkim.amazonses.com"]
}

module "search_gov__email_security" {
  source = "./email_security"

  zone_id     = aws_route53_zone.search_toplevel.zone_id
  txt_records = ["v=spf1 include:amazonses.com include:mail.zendesk.com include:_spf.google.com -all"]
}

output "search_ns" {
  value = aws_route53_zone.search_toplevel.name_servers
}

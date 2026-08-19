resource "aws_route53_zone" "notify_gov_zone" {
  name = "notify.gov."

  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "notify_gov_beta_acmechallenge" {
  zone_id = aws_route53_zone.notify_gov_zone.zone_id
  name    = "_acme-challenge.beta"
  type    = "CNAME"

  ttl     = 600
  records = ["_acme-challenge.beta.notify.gov.external-domains-production.cloud.gov"]
}

resource "aws_route53_record" "notify_gov_beta_cname" {
  zone_id = aws_route53_zone.notify_gov_zone.zone_id
  name    = "beta"
  type    = "CNAME"

  ttl     = 600
  records = ["beta.notify.gov.external-domains-production.cloud.gov"]
}

resource "aws_route53_record" "notify_gov_root_acmechallenge" {
  zone_id = aws_route53_zone.notify_gov_zone.zone_id
  name    = "_acme-challenge"
  type    = "CNAME"

  ttl     = 600
  records = ["_acme-challenge.notify.gov.external-domains-production.cloud.gov"]
}

resource "aws_route53_record" "notify_gov_root_a" {
  zone_id = aws_route53_zone.notify_gov_zone.zone_id
  name    = "notify.gov."
  type    = "A"

  alias {
    name                   = "d3ip8kz71rxi2w.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "notify_gov_root_aaaa" {
  zone_id = aws_route53_zone.notify_gov_zone.zone_id
  name    = "notify.gov."
  type    = "AAAA"

  alias {
    name                   = "d3ip8kz71rxi2w.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "notify_gov_www_acmechallenge" {
  zone_id = aws_route53_zone.notify_gov_zone.zone_id
  name    = "_acme-challenge.www"
  type    = "CNAME"

  ttl     = 600
  records = ["_acme-challenge.www.notify.gov.external-domains-production.cloud.gov"]
}

resource "aws_route53_record" "notify_gov_www_cname" {
  zone_id = aws_route53_zone.notify_gov_zone.zone_id
  name    = "www"
  type    = "CNAME"

  ttl     = 600
  records = ["www.notify.gov.external-domains-production.cloud.gov"]
}

resource "aws_route53_record" "notify_gov_dkim0" {
  zone_id = aws_route53_zone.notify_gov_zone.zone_id
  name    = "eku6g65dhk3u5cl7hnj2o7vplsct3zky._domainkey"
  type    = "CNAME"

  ttl     = 600
  records = ["eku6g65dhk3u5cl7hnj2o7vplsct3zky.dkim.amazonses.com"]
}

resource "aws_route53_record" "notify_gov_dkim1" {
  zone_id = aws_route53_zone.notify_gov_zone.zone_id
  name    = "an4gup5xe6a567hnjdyobxxqysuqirsj._domainkey"
  type    = "CNAME"

  ttl     = 600
  records = ["an4gup5xe6a567hnjdyobxxqysuqirsj.dkim.amazonses.com"]
}

resource "aws_route53_record" "notify_gov_dkim2" {
  zone_id = aws_route53_zone.notify_gov_zone.zone_id
  name    = "uf3w5htg3qjj4ehgf2ntgewzey7a2zt2._domainkey"
  type    = "CNAME"

  ttl     = 600
  records = ["uf3w5htg3qjj4ehgf2ntgewzey7a2zt2.dkim.amazonses.com"]
}

resource "aws_route53_record" "notify_gov_dmarc" {
  zone_id = aws_route53_zone.notify_gov_zone.zone_id
  name    = "_dmarc"
  type    = "TXT"

  ttl     = 600
  records = ["v=DMARC1; p=reject; pct=100; fo=1; ri=86400; rua=mailto:tts-notify-alerts@gsa.gov,mailto:dmarcreports@gsa.gov,mailto:reports@dmarc.cyber.dhs.gov; ruf=mailto:tts-notify-alerts@gsa.gov,mailto:dmarcfailures@gsa.gov"]
}

resource "aws_route53_record" "notify_gov_spf" {
  zone_id = aws_route53_zone.notify_gov_zone.zone_id
  name    = "mail"
  type    = "TXT"

  ttl     = 600
  records = ["v=spf1 include:amazonses.com ~all"]
}

resource "aws_route53_record" "notify_gov_txt" {
  zone_id = aws_route53_zone.notify_gov_zone.zone_id
  name    = ""
  type    = "TXT"

  ttl     = 600
  records = ["v=spf1 include:amazonses.com ~all"]
}

resource "aws_route53_record" "notify_gov_mx" {
  zone_id = aws_route53_zone.notify_gov_zone.zone_id
  name    = "mail"
  type    = "MX"

  ttl     = 600
  records = ["10 feedback-smtp.us-gov-west-1.amazonses.com"]
}

resource "aws_route53_record" "notify_gov_ssb_ns" {
  zone_id = aws_route53_zone.notify_gov_zone.zone_id
  name    = "ssb"
  type    = "NS"

  ttl = 600
  records = [
    "ns-1030.awsdns-00.org",
    "ns-1907.awsdns-46.co.uk",
    "ns-71.awsdns-08.com",
    "ns-851.awsdns-42.net"
  ]
}

resource "aws_route53_record" "notify_gov_ssb_ds" {
  zone_id = aws_route53_zone.notify_gov_zone.zone_id
  name    = "ssb"
  type    = "DS"

  ttl     = 600
  records = ["62629 13 2 2626E4C8594EA7F41B0F8C471FA50F9334A33F8E4EC17FD38556D90EB926163E"]
}

output "notify_gov_ns" {
  value = aws_route53_zone.notify_gov_zone.name_servers
}

resource "aws_route53_zone" "innovation_toplevel" {
  name = "innovation.gov"

  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "innovation_gov_apex" {
  zone_id = aws_route53_zone.innovation_toplevel.zone_id
  name    = "innovation.gov."
  type    = "A"

  alias {
    name                   = "d2ntl68ywjm643.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "innovation_gov_apex_aaaa" {
  zone_id = aws_route53_zone.innovation_toplevel.zone_id
  name    = "innovation.gov."
  type    = "AAAA"

  alias {
    name                   = "d2ntl68ywjm643.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "innovation_gov_www" {
  zone_id = aws_route53_zone.innovation_toplevel.zone_id
  name    = "www.innovation.gov."
  type    = "A"

  alias {
    name                   = "d2ntl68ywjm643.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "innovation_gov_www_aaaa" {
  zone_id = aws_route53_zone.innovation_toplevel.zone_id
  name    = "www.innovation.gov."
  type    = "AAAA"

  alias {
    name                   = "d2ntl68ywjm643.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "acme_challenge_permitting_innovation_gov_cname" {
  zone_id = aws_route53_zone.innovation_toplevel.zone_id
  name    = "_acme-challenge.permitting.innovation.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.permitting.innovation.gov.external-domains-production.cloud.gov."]
}

module "innovation_gov__email_security" {
  source  = "./email_security"
  zone_id = aws_route53_zone.innovation_toplevel.zone_id
}

output "innovation_ns" {
  value = aws_route53_zone.innovation_toplevel.name_servers
}

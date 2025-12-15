# ------------------------------------------
# WELCOME to the DNS records for Usability.gov
# Before making edits, please reach out to #digitalgov (in TTS Slack) or email digitalgov@gsa.gov
# ------------------------------------------

resource "aws_route53_zone" "usability_toplevel" {
  name = "usability.gov"
  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "usability_gov_apex" {
  zone_id = aws_route53_zone.usability_toplevel.zone_id
  name    = "usability.gov."
  type    = "A"

  alias {
    name                   = "d2yghjaoiuwpg5.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "usability_gov_apex_aaaa" {
  zone_id = aws_route53_zone.usability_toplevel.zone_id
  name    = "usability.gov."
  type    = "AAAA"

  alias {
    name                   = "d2yghjaoiuwpg5.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

# www.usability.gov — redirects to digital.gov/topics/usability through pages_redirect
resource "aws_route53_record" "usability_gov_www" {
  zone_id = aws_route53_zone.usability_toplevel.zone_id
  name    = "www.usability.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["www.usability.gov.external-domains-production.cloud.gov."]
}

# Compliance and ACME records -------------------------------

module "usability_gov__email_security" {
  source  = "./email_security"
  zone_id = aws_route53_zone.usability_toplevel.zone_id
}

# ACME Challenge records

# usability.gov CNAME / ACME Challenge
resource "aws_route53_record" "usability_gov__acme-challenge_cname" {
  zone_id = aws_route53_zone.usability_toplevel.zone_id
  name    = "_acme-challenge.usability.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.usability.gov.external-domains-production.cloud.gov."]
}

# www.usability.gov CNAME / ACME Challenge
resource "aws_route53_record" "www_usability_gov__acme-challenge_cname" {
  zone_id = aws_route53_zone.usability_toplevel.zone_id
  name    = "_acme-challenge.www.usability.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.www.usability.gov.external-domains-production.cloud.gov."]
}

output "usability_ns" {
  value = aws_route53_zone.usability_toplevel.name_servers
}

resource "aws_route53_zone" "usa_gov_zone" {
  name = "usa.gov."
  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "usa_gov_analytics_challenge" {
  zone_id = aws_route53_zone.usa_gov_zone.zone_id
  name    = "_acme-challenge.analytics.usa.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.analytics.usa.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "usa_gov_analytics_usa_gov_a" {
  zone_id = aws_route53_zone.usa_gov_zone.zone_id
  name    = "analytics.usa.gov."
  type    = "A"
  alias {
    name                   = "dkm80j4hktly2.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "usa_gov_analytics_usa_gov_aaaa" {
  zone_id = aws_route53_zone.usa_gov_zone.zone_id
  name    = "analytics.usa.gov."
  type    = "AAAA"
  alias {
    name                   = "dkm80j4hktly2.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

# USWDS ------------------------------------------------

#module "usa_gov__components_standards_usa_gov_redirect" {
#  source = "mediapop/redirect/aws"
#  version = "1.2.1"

#  domains = {
#    "usa.gov." = ["components.standards.usa.gov"]
#  }

#  redirect_to = "components.designsystem.digital.gov"
#}

#module "usa_gov__standards_usa_gov_redirect" {
#  source = "mediapop/redirect/aws"
#  version = "1.2.1"

#  domains = {
#    "usa.gov." = ["standards.usa.gov"]
#  }

#  redirect_to = "designsystem.digital.gov"
#}

output "usa_gov_ns" {
  value = aws_route53_zone.usa_gov_zone.name_servers
}

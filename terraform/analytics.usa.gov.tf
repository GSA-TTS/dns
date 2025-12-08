resource "aws_route53_zone" "analytics_usa_gov_zone" {
  name = "analytics.usa.gov."

  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "analytics_usa_gov_analytics_usa_gov_a" {
  zone_id = aws_route53_zone.analytics_usa_gov_zone.zone_id
  name    = "analytics.usa.gov."
  type    = "A"

  alias {
    name                   = "d2rprfiomwib2l.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

output "analytics_usa_gov_ns" {
  value = aws_route53_zone.analytics_usa_gov_zone.name_servers
}

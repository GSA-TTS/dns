resource "aws_route53_zone" "pulse_cio_gov_zone" {
  name = "pulse.cio.gov."

  tags = {
    Project = "dns"
    client  = "OGP-20150420-20150930-01"
  }
}

locals {
  pulse_cloudfront = "d1molo8p4za8ef.cloudfront.net."
}

resource "aws_route53_record" "pulse_cio_gov_pulse_cio_gov_a" {
  zone_id = aws_route53_zone.pulse_cio_gov_zone.zone_id
  name    = "pulse.cio.gov."
  type    = "A"

  alias {
    name                   = local.pulse_cloudfront
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "pulse_cio_gov_pulse_cio_gov_aaaa" {
  zone_id = aws_route53_zone.pulse_cio_gov_zone.zone_id
  name    = "pulse.cio.gov."
  type    = "AAAA"

  alias {
    name                   = local.pulse_cloudfront
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "pulse_cio_gov_staging_pulse_cio_gov_cname" {
  zone_id = aws_route53_zone.pulse_cio_gov_zone.zone_id
  name    = "staging.pulse.cio.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["d1991ybttt3nlc.cloudfront.net."]
}

output "pulse_cio_gov_ns" {
  value = aws_route53_zone.pulse_cio_gov_zone.name_servers
}

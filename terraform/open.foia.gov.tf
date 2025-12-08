resource "aws_route53_zone" "open_foia_gov_zone" {
  name = "open.foia.gov."

  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "open_foia_gov_open_foia_gov_a" {
  zone_id = aws_route53_zone.open_foia_gov_zone.zone_id
  name    = "open.foia.gov."
  type    = "A"

  alias {
    name                   = "d23kapr45ru7n0.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "open_foia_gov_open_foia_gov_aaaa" {
  zone_id = aws_route53_zone.open_foia_gov_zone.zone_id
  name    = "open.foia.gov."
  type    = "AAAA"

  alias {
    name                   = "d23kapr45ru7n0.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}


resource "aws_route53_record" "open_foia_gov_17fdb56b3309467b9d43ad74888c07e2_open_foia_gov_cname" {
  zone_id = aws_route53_zone.open_foia_gov_zone.zone_id
  name    = "17fdb56b3309467b9d43ad74888c07e2.open.foia.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["6ca1ebd4ffc4a9400ac70f600b7139bdd92625df.comodoca.com."]
}

output "open_foia_gov_ns" {
  value = aws_route53_zone.open_foia_gov_zone.name_servers
}

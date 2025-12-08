resource "aws_route53_zone" "collegescorecard_ed_gov_zone" {
  name = "collegescorecard.ed.gov."

  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "collegescorecard_ed_gov_collegescorecard_ed_gov_a" {
  zone_id = aws_route53_zone.collegescorecard_ed_gov_zone.zone_id
  name    = "collegescorecard.ed.gov."
  type    = "A"

  alias {
    name                   = "d1a8vwb3lfw7jl.cloudfront.net."
    zone_id                = local.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "collegescorecard_ed_gov_5bfe0b9d9aefc19191b8c65679d9cedb_collegescorecard_ed_gov_cname" {
  zone_id = aws_route53_zone.collegescorecard_ed_gov_zone.zone_id
  name    = "5bfe0b9d9aefc19191b8c65679d9cedb.collegescorecard.ed.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["dd5b59f730ee292cbcc93e5f375af63f3d155db2.comodoca.com."]
}

resource "aws_route53_record" "collegescorecard_ed_gov_download_collegescorecard_ed_gov_cname" {
  zone_id = aws_route53_zone.collegescorecard_ed_gov_zone.zone_id
  name    = "download.collegescorecard.ed.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["ed-public-download.apps.cloud.gov"]
}

output "collegescorecard_ed_gov_ns" {
  value = aws_route53_zone.collegescorecard_ed_gov_zone.name_servers
}

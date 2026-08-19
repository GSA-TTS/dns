resource "aws_route53_zone" "notify_gov_zone" {
  name = "notify.gov."

  tags = {
    Project = "dns"
  }
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

output "notify_gov_ns" {
  value = aws_route53_zone.notify_gov_zone.name_servers
}

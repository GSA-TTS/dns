resource "aws_route53_zone" "digitalgov_gov_zone" {
  name = "digitalgov.gov."
  tags {
    Project = "dns"
  }
}

# digitalgov.gov
resource "aws_route53_record" "digitalgov_gov_apex" {
  zone_id = "${aws_route53_zone.digitalgov_gov_zone.zone_id}"
  name = "digitalgov.gov."
  type = "A"

  alias {
    name = "djce1rrjucuix.cloudfront.net."
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

# www.digitalgov.gov
resource "aws_route53_record" "digitalgov_gov_www" {
  zone_id = "${aws_route53_zone.digitalgov_gov_zone.zone_id}"
  name = "www.digitalgov.gov."
  type = "A"

  alias {
    name = "djce1rrjucuix.cloudfront.net."
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

# demo.digitalgov.gov
resource "aws_route53_record" "demo_digitalgov_gov_a" {
  zone_id = "${aws_route53_zone.digitalgov_gov_zone.zone_id}"
  name = "demo.digitalgov.gov."
  type = "A"

  alias {
    name = "d3oyi0vhjafspr.cloudfront.net."
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

# usdigitalregistry.digitalgov.gov
resource "aws_route53_record" "usdigitalregistry_digitalgov_gov_a" {
  zone_id = "${aws_route53_zone.digitalgov_gov_zone.zone_id}"
  name = "usdigitalregistry.digitalgov.gov."
  type = "A"

  alias {
    name = "XXXXXXXXXXXXXXXXXXXX."
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

# dap.digitalgov.gov
resource "aws_route53_record" "dap_digitalgov_gov_a" {
  zone_id = "${aws_route53_zone.digitalgov_gov_zone.zone_id}"
  name = "dap.digitalgov.gov."
  type = "A"

  alias {
    name = "XXXXXXXXXXXXXXXXXXXX."
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

# search.digitalgov.gov
resource "aws_route53_record" "search_digitalgov_gov_a" {
  zone_id = "${aws_route53_zone.digitalgov_gov_zone.zone_id}"
  name = "search.digitalgov.gov."
  type = "A"

  alias {
    name = "XXXXXXXXXXXXXXXXXXXX."
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

# summit.digitalgov.gov
resource "aws_route53_record" "summit_digitalgov_gov_a" {
  zone_id = "${aws_route53_zone.digitalgov_gov_zone.zone_id}"
  name = "summit.digitalgov.gov."
  type = "A"

  alias {
    name = "XXXXXXXXXXXXXXXXXXXX."
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

# openopps.digitalgov.gov - A
resource "aws_route53_record" "digitalgov_gov_openopps_digitalgov_gov_a" {
  zone_id = "${aws_route53_zone.digitalgov_gov_zone.zone_id}"
  name = "openopps.digitalgov.gov."
  type = "A"
  alias {
    name = "d11og6pgwhrztr.cloudfront.net."
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

# openopps.digitalgov.gov — AAAA
resource "aws_route53_record" "digitalgov_gov_openopps_digitalgov_gov_aaaa" {
  zone_id = "${aws_route53_zone.digitalgov_gov_zone.zone_id}"
  name = "openopps.digitalgov.gov."
  type = "AAAA"
  alias {
    name = "d11og6pgwhrztr.cloudfront.net."
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

# openopps.digitalgov.gov — MX
resource "aws_route53_record" "digitalgov_gov_openopps_digitalgov_gov_mx" {
  zone_id = "${aws_route53_zone.digitalgov_gov_zone.zone_id}"
  name = "openopps.digitalgov.gov."
  type = "MX"
  ttl = 300
  records = ["10	30288227.in1.mandrillapp.com", "20	30288227.in2.mandrillapp.com"]
}

# openopps.digitalgov.gov — TXT
resource "aws_route53_record" "digitalgov_gov_openopps_digitalgov_gov_txt" {
  zone_id = "${aws_route53_zone.digitalgov_gov_zone.zone_id}"
  name = "openopps.digitalgov.gov."
  type = "TXT"
  ttl = 300
  records = ["v=spf1 include:spf.mandrillapp.com ?all"]
}

# openopps.digitalgov.gov — Mandrill TXT
resource "aws_route53_record" "digitalgov_gov_mandrill__domainkey_openopps_digitalgov_gov_txt" {
  zone_id = "${aws_route53_zone.digitalgov_gov_zone.zone_id}"
  name = "mandrill._domainkey.openopps.digitalgov.gov."
  type = "TXT"
  ttl = 300
  records = ["v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCrLHiExVd55zd/IQ/J/mRwSRMAocV/hMB3jXwaHH36d9NaVynQFYV8NaWi69c1veUtRzGt7yAioXqLj7Z4TeEUoOLgrKsn8YnckGs9i3B3tVFB+Ch/4mPhXWiNfNdynHWBcPcbJ8kjEQ2U8y78dHZj1YeRXXVvWob2OaKynO8/lQIDAQAB;"]
}

output "digitalgov_gov_ns" {
  value="${aws_route53_zone.digitalgov_gov_zone.name_servers}"
}

data "aws_caller_identity" "current" {}

resource "aws_route53_zone" "datagov_zone" {

  name = "data.gov"
  tags = {
    Project = "dns"
  }
}

# Create a KMS key for DNSSEC signing
#checkov:skip=CKV_AWS_33:Required for DNSSEC configuration with Route53
resource "aws_kms_key" "datagov_zone" {

  # See Route53 key requirements here: 
  # https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring-dnssec-cmk-requirements.html
  customer_master_key_spec = "ECC_NIST_P256"
  deletion_window_in_days  = 7
  key_usage                = "SIGN_VERIFY"
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "kms:DescribeKey",
          "kms:GetPublicKey",
          "kms:Sign",
        ],
        Effect = "Allow"
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        }
        Sid      = "Allow Route 53 DNSSEC Service",
        Resource = "*"
      },
      {
        Action = "kms:CreateGrant",
        Effect = "Allow"
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        }
        Sid      = "Allow Route 53 DNSSEC Service to CreateGrant",
        Resource = "*"
        Condition = {
          Bool = {
            "kms:GrantIsForAWSResource" = "true"
          }
        }
      },
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          # checkov:skip=CKV_AWS_33: "Ensure KMS key policy does not contain wildcard (*) principal"
          AWS = "*"
        }
        Resource = "*"
        Sid      = "IAM User Permissions"
      },
    ]
    Version = "2012-10-17"
  })
}

# Make it easier for admins to identify the key in the KMS console
resource "aws_kms_alias" "datagov_zone" {
  name          = "alias/DNSSEC-${replace(aws_route53_zone.datagov_zone.name, "/[^a-zA-Z0-9:/_-]/", "-")}"
  target_key_id = aws_kms_key.datagov_zone.key_id
}

resource "aws_route53_key_signing_key" "datagov_zone" {
  hosted_zone_id             = aws_route53_zone.datagov_zone.id
  key_management_service_arn = aws_kms_key.datagov_zone.arn
  name                       = "data.gov"
}

resource "aws_route53_hosted_zone_dnssec" "datagov_zone" {
  depends_on = [
    aws_route53_key_signing_key.datagov_zone
  ]
  hosted_zone_id = aws_route53_key_signing_key.datagov_zone.hosted_zone_id
}
locals {
  datagov_ns_record    = tolist(["NS", "data.gov", "[ ${join(", \n", [for s in aws_route53_zone.datagov_zone.name_servers : format("%q", s)])} ]"])
  datagov_ds_record    = tolist(["DS", "data.gov", aws_route53_key_signing_key.datagov_zone.ds_record])
  datagov_instructions = "Create NS and DS records in the .gov zone with the values indicated."
}
output "datagov_ds_record" {
  depends_on = [
    aws_route53_hosted_zone_dnssec.datagov_zone
  ]
  value = [
    local.datagov_ds_record
  ]
}

output "datagov_ns_record" {
  value = [
    local.datagov_ns_record
  ]
}

output "datagov_instructions" {
  value = local.datagov_instructions
}




resource "aws_route53_record" "datagov_34193244109_a" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "data.gov"
  type    = "A"

  alias {
    name                   = "dg7ira9sfp69m.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "datagov_aaaa" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "data.gov"
  type    = "AAAA"

  alias {
    name                   = "dg7ira9sfp69m.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}


resource "aws_route53_record" "datagov_manage101771786_a" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "manage"
  type    = "A"

  ttl     = 300
  records = ["10.177.17.86"]

}


resource "aws_route53_record" "datagov_originssmallbusiness1981012551_a" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "origins-smallbusiness"
  type    = "A"

  ttl     = 300
  records = ["198.10.125.51"]

}


resource "aws_route53_record" "datagov__caa" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = ""
  type    = "CAA"

  ttl = 300
  records = [
    "0 issue \"awstrust.com\"",
    "0 issue \"letsencrypt.org\"",
    "0 issue \"amazonaws.com\"",
    "0 issue \"amazontrust.com\"",
    "0 issue \"digicert.com\"",
    "0 issue \"amazon.com\"",
  ]

}


resource "aws_route53_record" "datagov_acmechallengeacmechallengecatalogbetadatagovexternaldomainsproductioncloudgov_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "_acme-challenge.catalog-beta"
  type    = "CNAME"

  ttl     = 300
  records = ["_acme-challenge.catalog-beta.data.gov.external-domains-production.cloud.gov."]

}


resource "aws_route53_record" "datagov_acmechallengeacmechallengeharvestdatagovexternaldomainsproductioncloudgov_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "_acme-challenge.harvest"
  type    = "CNAME"

  ttl     = 300
  records = ["_acme-challenge.harvest.data.gov.external-domains-production.cloud.gov."]

}


resource "aws_route53_record" "datagov_acmechallengeacmechallengedatagovexternaldomainsproductioncloudgov_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "_acme-challenge"
  type    = "CNAME"

  ttl     = 300
  records = ["_acme-challenge.data.gov.external-domains-production.cloud.gov."]

}


resource "aws_route53_record" "datagov_acmechallengecatalogacmechallengecatalogdatagovexternaldomainsproductioncloudgov_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "_acme-challenge.catalog"
  type    = "CNAME"

  ttl     = 300
  records = ["_acme-challenge.catalog.data.gov.external-domains-production.cloud.gov."]

}


resource "aws_route53_record" "datagov_acmechallengeclimateacmechallengeclimatedatagovexternaldomainsproductioncloudgov_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "_acme-challenge.climate"
  type    = "CNAME"

  ttl     = 300
  records = ["_acme-challenge.climate.data.gov.external-domains-production.cloud.gov."]

}


resource "aws_route53_record" "datagov_acmechallengedashboardacmechallengedashboarddatagovexternaldomainsproductioncloudgov_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "_acme-challenge.dashboard"
  type    = "CNAME"

  ttl     = 300
  records = ["_acme-challenge.dashboard.data.gov.external-domains-production.cloud.gov."]

}


resource "aws_route53_record" "datagov_acmechallengefederationacmechallengefederationdatagovexternaldomainsproductioncloudgov_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "_acme-challenge.federation"
  type    = "CNAME"

  ttl     = 300
  records = ["_acme-challenge.federation.data.gov.external-domains-production.cloud.gov."]

}


resource "aws_route53_record" "datagov_acmechallengeinventoryacmechallengeinventorydatagovexternaldomainsproductioncloudgov_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "_acme-challenge.inventory"
  type    = "CNAME"

  ttl     = 300
  records = ["_acme-challenge.inventory.data.gov.external-domains-production.cloud.gov."]

}


resource "aws_route53_record" "datagov_acmechallengewwwacmechallengewwwdatagovexternaldomainsproductioncloudgov_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "_acme-challenge.www"
  type    = "CNAME"

  ttl     = 300
  records = ["_acme-challenge.www.data.gov.external-domains-production.cloud.gov."]

}


resource "aws_route53_record" "datagov_admincatalogadmincatalogbspdatagov_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "admin-catalog"
  type    = "CNAME"

  ttl     = 300
  records = ["admin-catalog-bsp.data.gov"]

}


resource "aws_route53_record" "datagov_catalogd2s65feajdp88kcloudfrontnet_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "catalog"
  type    = "CNAME"

  ttl     = 300
  records = ["d2s65feajdp88k.cloudfront.net"]

}


resource "aws_route53_record" "datagov_catalogstaged1u59lafwydg4acloudfrontnet_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "catalog-stage"
  type    = "CNAME"

  ttl     = 300
  records = ["d1u59lafwydg4a.cloudfront.net"]

}


resource "aws_route53_record" "datagov_catalogdevd2jqk88ququ1n9cloudfrontnet_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "catalog-dev"
  type    = "CNAME"

  ttl     = 300
  records = ["d2jqk88ququ1n9.cloudfront.net"]

}


resource "aws_route53_record" "datagov_catalogbetadatagovexternaldomainsproductioncloudgov_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "catalog-beta"
  type    = "CNAME"

  ttl     = 300
  records = ["catalog-beta.data.gov.external-domains-production.cloud.gov."]

}


resource "aws_route53_record" "datagov_harvestdatagovexternaldomainsproductioncloudgov_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "harvest"
  type    = "CNAME"

  ttl     = 300
  records = ["harvest.data.gov.external-domains-production.cloud.gov."]

}


resource "aws_route53_record" "datagov_climateclimatedatagovexternaldomainsproductioncloudgov_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "climate"
  type    = "CNAME"

  ttl     = 300
  records = ["climate.data.gov.external-domains-production.cloud.gov."]

}


resource "aws_route53_record" "datagov_dashboarddashboarddatagovexternaldomainsproductioncloudgov_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "dashboard"
  type    = "CNAME"

  ttl     = 300
  records = ["dashboard.data.gov.external-domains-production.cloud.gov."]

}


resource "aws_route53_record" "datagov_federationfederationdatagovexternaldomainsproductioncloudgov_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "federation"
  type    = "CNAME"

  ttl     = 300
  records = ["federation.data.gov.external-domains-production.cloud.gov."]

}

resource "aws_route53_record" "datagov_inventoryinventorybspdatagov_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "inventory"
  type    = "CNAME"

  ttl     = 300
  records = ["inventory.data.gov.external-domains-production.cloud.gov."]

}


resource "aws_route53_record" "datagov_originsdatagovwwwdatalbgsaakadnsnet_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "origins-data-gov"
  type    = "CNAME"

  ttl     = 300
  records = ["wwwdata.lb.gsa.akadns.net"]

}


resource "aws_route53_record" "datagov_resourcesd9v2xy0mx1ayqcloudfrontnet_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "resources"
  type    = "CNAME"

  ttl     = 300
  records = ["d9v2xy0mx1ayq.cloudfront.net"]

}


resource "aws_route53_record" "datagov_resourcesstagingd13l8e1a7ekkcacloudfrontnet_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "resources-staging"
  type    = "CNAME"

  ttl     = 300
  records = ["d13l8e1a7ekkca.cloudfront.net"]

}

resource "aws_route53_record" "datagov_strategyd3mxkpq217356pcloudfrontnet_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "strategy"
  type    = "CNAME"

  ttl     = 300
  records = ["d3mxkpq217356p.cloudfront.net"]

}


resource "aws_route53_record" "datagov_strategystagingd97qwv40ba5n0cloudfrontnet_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "strategy-staging"
  type    = "CNAME"

  ttl     = 300
  records = ["d97qwv40ba5n0.cloudfront.net"]

}

resource "aws_route53_record" "datagov_wwwd36thseoamvwaacloudfrontnet_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "www"
  type    = "CNAME"

  ttl     = 300
  records = ["www.data.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "datagov_api_ns" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "api"
  type    = "NS"

  ttl = 300
  records = [
    "ns-738.awsdns-28.net.",
    "ns-1612.awsdns-09.co.uk.",
    "ns-468.awsdns-58.com.",
    "ns-1281.awsdns-32.org."
  ]
}

resource "aws_route53_record" "datagov_ssb_ns" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "ssb"
  type    = "NS"

  ttl = 300
  records = [
    "ns-658.awsdns-18.net.",
    "ns-146.awsdns-18.com.",
    "ns-1439.awsdns-51.org.",
    "ns-1688.awsdns-19.co.uk."
  ]
}

resource "aws_route53_record" "datagov_ssb_ds" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "ssb"
  type    = "DS"

  ttl     = 30
  records = ["4862 13 2 F9C2CD8A4F6AF7EFE48A630EE4AD53431636310D1306A7608D27C7B011CA20B9"]

}

resource "aws_route53_record" "datagov_ssbdev_ns" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "ssb-dev"
  type    = "NS"

  ttl = 300
  records = [
    "ns-1839.awsdns-37.co.uk.",
    "ns-1422.awsdns-49.org.",
    "ns-673.awsdns-20.net.",
    "ns-297.awsdns-37.com."
  ]
}

resource "aws_route53_record" "datagov_ssbdev_ds" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "ssb-dev"
  type    = "DS"

  ttl     = 30
  records = ["46864 13 2 B834DCEE0727D7864D11E31276F3BDE5B35F7D9744F3BEFF042F21B9FF864E1D"]

}

resource "aws_route53_record" "datagov_ssbstaging_ns" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "ssb-staging"
  type    = "NS"

  ttl = 300
  records = [
    "ns-1903.awsdns-45.co.uk.",
    "ns-510.awsdns-63.com.",
    "ns-890.awsdns-47.net.",
    "ns-1056.awsdns-04.org."
  ]
}

resource "aws_route53_record" "datagov_ssbstaging_ds" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "ssb-staging"
  type    = "DS"

  ttl     = 30
  records = ["28358 13 2 7D70709ECEEA84A93A19277C126F2747AB5655A285731F7D31F39E24F4DD5040"]

}

resource "aws_route53_record" "datagov__txt" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = ""
  type    = "TXT"

  ttl = 300
  records = [
    "621df521f1e44ac69a670f325dc86889",
    "v=spf1 ip4:34.193.244.109 include:gsa.gov ~all",
    "n6fgn8dyh1hhqsmghskdplss7zp7yt7q",
    "google-site-verification=K1_M1KkxyZYMiqHHAmlUVcXgYxV6myWSNYAyLrUk_PA"
  ]
}

resource "aws_route53_record" "datagov_mloj922e44u1o54qmtbqbi4k6r_txt" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "@"
  type    = "TXT"

  ttl     = 300
  records = ["mloj922e44u1o54qmtbqbi4k6r"]

}


resource "aws_route53_record" "datagov_acmechallengeresourcesW9OAmioR3ViZvIRze2pvvmDgNtVaYqcP2Cft0lgcU_txt" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "_acme-challenge.resources"
  type    = "TXT"

  ttl     = 300
  records = ["W9OAmi-oR3ViZvIRze2pvvmDgNtVaYqcP2Cft_0lgcU"]

}


resource "aws_route53_record" "datagov_acmechallengeresourcesstagingCTRQ5trgMF0KKgUZk14YJSRlGD36BWeQENmK8XAWk8_txt" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "_acme-challenge.resources-staging"
  type    = "TXT"

  ttl     = 300
  records = ["CTR-Q5trgMF0KKgUZk14YJSRlGD36BWeQENmK8XAWk8"]

}

resource "aws_route53_record" "datagov_acmechallengestrategyHjy5O04QmUqj4qgVY4jRisqf9oMl3G3z0pRo4Irlcg_txt" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "_acme-challenge.strategy"
  type    = "TXT"

  ttl     = 300
  records = ["H_jy5O04QmUqj4qgVY4jRisqf9oMl3G3z0pRo4Irlcg"]

}


resource "aws_route53_record" "datagov_acmechallengestrategystagingh6eondVFdMUnFzj4flKL1jDbO2DL1pVFHdoo1J43k_txt" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "_acme-challenge.strategy-staging"
  type    = "TXT"

  ttl     = 300
  records = ["h6eondV-FdM_UnFzj4flKL1jDbO2DL1pVFHdoo1J43k"]

}


resource "aws_route53_record" "datagov_dmarcvDMARC1prejectfo1pct100ri86400ruamailtogsaloginruaagaricommailtodmarcreportsgsagovmailtoreportsdmarccyberdhsgovrufmailtogsaloginrufagaricommailtodmarcfailuresgsagov_txt" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "_dmarc"
  type    = "TXT"

  ttl     = 300
  records = ["v=DMARC1; p=reject; fo=1; pct=100; ri=86400; rua=mailto:gsalogin@rua.agari.com,mailto:dmarcreports@gsa.gov,mailto:reports@dmarc.cyber.dhs.gov; ruf=mailto:gsalogin@ruf.agari.com,mailto:dmarcfailures@gsa.gov"]

}


resource "aws_route53_record" "datagov_00bc66d9e476816ba3d1521a99299217catalog8f05f6bd13f92abbf416a1a1bebd7a94xmkpffzlvdacmvalidationsaws_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "_00bc66d9e476816ba3d1521a99299217.catalog"
  type    = "CNAME"

  ttl     = 300
  records = ["_8f05f6bd13f92abbf416a1a1bebd7a94.xmkpffzlvd.acm-validations.aws."]

}


resource "aws_route53_record" "datagov_bafcc0ee223ea343cb6b478aa300a182catalogstagefb09f0b389b6e9a8eeefc817364e9df9cltjbwlkcyacmvalidationsaws_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "_bafcc0ee223ea343cb6b478aa300a182.catalog-stage.data.gov."
  type    = "CNAME"

  ttl     = 300
  records = ["_6860e6e39504b0ca7f5dcbd5ba8f678c.cltjbwlkcy.acm-validations.aws."]

}


resource "aws_route53_record" "datagov_108d9367ec7e67814fe17cc2a0173a81catalogdevfb09f0b389b6e9a8eeefc817364e9df9cltjbwlkcyacmvalidationsaws_cname" {
  zone_id = aws_route53_zone.datagov_zone.zone_id
  name    = "_108d9367ec7e67814fe17cc2a0173a81.catalog-dev.data.gov."
  type    = "CNAME"

  ttl     = 300
  records = ["_fb09f0b389b6e9a8eeefc817364e9df9.cltjbwlkcy.acm-validations.aws."]

}

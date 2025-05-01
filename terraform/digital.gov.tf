# ------------------------------------------
# WELCOME to the DNS records for Digital.gov
# Before making edits, please reach out to #digitalgov (in TTS Slack) or email digitalgov@gsa.gov
# ------------------------------------------


resource "aws_route53_zone" "digital_toplevel" {
  name = "digital.gov"

  tags = {
    Project = "dns"
  }
}

##
##   _____  _   _  _____ _____ ______ _____ 
##  |  __ \| \ | |/ ____/ ____|  ____/ ____|
##  | |  | |  \| | (___| (___ | |__ | |     
##  | |  | | . ` |\___ \\___ \|  __|| |     
##  | |__| | |\  |____) |___) | |___| |____ 
##  |_____/|_| \_|_____/_____/|______\_____|
##

# Create a KMS key for DNSSEC signing
#checkov:skip=CKV_AWS_33:Required for DNSSEC configuration with Route53                         
resource "aws_kms_key" "digital_gov_dnssec_zone" {

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
resource "aws_kms_alias" "digital_gov_dnssec_zone" {
  name          = "alias/DNSSEC-${replace(aws_route53_zone.digital_toplevel.name, "/[^a-zA-Z0-9:/_-]/", "-")}"
  target_key_id = aws_kms_key.digital_gov_dnssec_zone.key_id
}

resource "aws_route53_key_signing_key" "digital_gov_dnssec_zone" {
  hosted_zone_id             = aws_route53_zone.digital_toplevel.id
  key_management_service_arn = aws_kms_key.digital_gov_dnssec_zone.arn
  name                       = "digital.gov"
}

resource "aws_route53_hosted_zone_dnssec" "digital_gov_dnssec_zone" {
  depends_on = [
    aws_route53_key_signing_key.digital_gov_dnssec_zone
  ]
  hosted_zone_id = aws_route53_key_signing_key.digital_gov_dnssec_zone.hosted_zone_id
}

##
##       _______  _   _  _____ _____ ______ _____ 
##      / /  __ \| \ | |/ ____/ ____|  ____/ ____|
##     / /| |  | |  \| | (___| (___ | |__ | |     
##    / / | |  | | . ` |\___ \\___ \|  __|| |     
##   / /  | |__| | |\  |____) |___) | |___| |____ 
##  /_/   |_____/|_| \_|_____/_____/|______\_____|
##


##
##  _____                         _ 
##  |  __ \                       | |
##  | |  | |_ __ _   _ _ __   __ _| |
##  | |  | | '__| | | | '_ \ / _` | |
##  | |__| | |  | |_| | |_) | (_| | |
##  |_____/|_|   \__,_| .__/ \__,_|_|
##                    | |            
##                    |_|            
##

##
##     _____           _         _   _         
##    |  _  |___ ___ _| |_ _ ___| |_|_|___ ___ 
##    |   __|  _| . | . | | |  _|  _| | . |   |
##    |__|  |_| |___|___|___|___|_| |_|___|_|_|
##

resource "aws_route53_record" "prod__acme_challenge_digital_gov_cname" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "_acme-challenge.digital.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.digital.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "prod__acme_challenge_www_digital_gov_cname" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "_acme-challenge.www.digital.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.www.digital.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "prod__acme_challenge_cms_digital_gov_cname" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "_acme-challenge.cms.digital.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.cms.digital.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "prod_cms_digital_gov_cname" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "cms.digital.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["cms.digital.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "digital_gov_digital_gov_a" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "digital.gov."
  type    = "A"
  alias {
    name                   = "d3arzeyfcjeh5j.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "digital_gov_digital_gov_aaaa" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "digital.gov."
  type    = "AAAA"
  alias {
    name                   = "d3arzeyfcjeh5j.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

# resource "aws_route53_record" "www_digital_gov_digital_gov_cname" {
#   zone_id = aws_route53_zone.digital_toplevel.zone_id
#   name    = "www.digital.gov."
#   type    = "CNAME"
#   ttl     = 120
#   records = ["digital.gov."]
# }

##
##       _ _____           _         _   _         
##      / |  _  |___ ___ _| |_ _ ___| |_|_|___ ___ 
##     / /|   __|  _| . | . | | |  _|  _| | . |   |
##    |_/ |__|  |_| |___|___|___|___|_| |_|___|_|_|
##

##
##     ____          
##    |    \ ___ _ _ 
##    |  |  | -_| | |
##    |____/|___|\_/ 
##

# resource "aws_route53_record" "dev__acme_challenge_cms-dev_digital_gov_cname" {
#   zone_id = aws_route53_zone.digital_toplevel.zone_id
#   name    = "_acme-challenge.cms-dev.digital.gov."
#   type    = "CNAME"
#   ttl     = 120
#   records = ["_acme-challenge.cms-dev.digital.gov.external-domains-production.cloud.gov."]
# }

# resource "aws_route53_record" "dev__acme_challenge_static-dev_digital_gov_cname" {
#   zone_id = aws_route53_zone.digital_toplevel.zone_id
#   name    = "_acme-challenge.static-dev.digital.gov."
#   type    = "CNAME"
#   ttl     = 120
#   records = ["_acme-challenge.static-dev.digital.gov.external-domains-production.cloud.gov."]
# }

# resource "aws_route53_record" "dev_cms-dev_digital_gov_cname" {
#   zone_id = aws_route53_zone.digital_toplevel.zone_id
#   name    = "cms-dev.digital.gov."
#   type    = "CNAME"
#   ttl     = 120
#   records = ["cms-dev.digital.gov.external-domains-production.cloud.gov."]
# }

# resource "aws_route53_record" "dev_static-dev_digital_gov_cname" {
#   zone_id = aws_route53_zone.digital_toplevel.zone_id
#   name    = "static-dev.digital.gov."
#   type    = "CNAME"
#   ttl     = 120
#   records = ["static-dev.digital.gov.external-domains-production.cloud.gov."]
# }

##
##       _ ____          
##      / |    \ ___ _ _ 
##     / /|  |  | -_| | |
##    |_/ |____/|___|\_/ 
##

##
##     _____ _           _         
##    |   __| |_ ___ ___|_|___ ___ 
##    |__   |  _| .'| . | |   | . |
##    |_____|_| |__,|_  |_|_|_|_  |
##                  |___|     |___|
##

# resource "aws_route53_record" "staging__acme_challenge_cms-staging_digital_gov_cname" {
#   zone_id = aws_route53_zone.digital_toplevel.zone_id
#   name    = "_acme-challenge.cms-staging.digital.gov."
#   type    = "CNAME"
#   ttl     = 120
#   records = ["_acme-challenge.cms-staging.digital.gov.external-domains-production.cloud.gov."]
# }

# resource "aws_route53_record" "staging__acme_challenge_static-staging_digital_gov_cname" {
#   zone_id = aws_route53_zone.digital_toplevel.zone_id
#   name    = "_acme-challenge.static-staging.digital.gov."
#   type    = "CNAME"
#   ttl     = 120
#   records = ["_acme-challenge.static-staging.digital.gov.external-domains-production.cloud.gov."]
# }

# resource "aws_route53_record" "staging_cms-staging_digital_gov_cname" {
#   zone_id = aws_route53_zone.digital_toplevel.zone_id
#   name    = "cms-staging.digital.gov."
#   type    = "CNAME"
#   ttl     = 120
#   records = ["cms-staging.digital.gov.external-domains-production.cloud.gov."]
# }

# resource "aws_route53_record" "staging_static-staging_digital_gov_cname" {
#   zone_id = aws_route53_zone.digital_toplevel.zone_id
#   name    = "static-staging.digital.gov."
#   type    = "CNAME"
#   ttl     = 120
#   records = ["static-staging.digital.gov.external-domains-production.cloud.gov."]
# }

##
##       _ _____ _           _         
##      / |   __| |_ ___ ___|_|___ ___ 
##     / /|__   |  _| .'| . | |   | . |
##    |_/ |_____|_| |__,|_  |_|_|_|_  |
##                      |___|     |___|
##

##  
##       _______                         _ 
##      / /  __ \                       | |
##     / /| |  | |_ __ _   _ _ __   __ _| |
##    / / | |  | | '__| | | | '_ \ / _` | |
##   / /  | |__| | |  | |_| | |_) | (_| | |
##  /_/   |_____/|_|   \__,_| .__/ \__,_|_|
##                           | |            
##                           |_|            
##  

##
## OLD PAGES RECORDS
##

# resource "aws_route53_record" "digital_gov_apex" {
#   zone_id = aws_route53_zone.digital_toplevel.zone_id
#   name    = "digital.gov."
#   type    = "A"

#   alias {
#     name                   = "d2q1i25any8vwy.cloudfront.net."
#     zone_id                = local.cloud_gov_cloudfront_zone_id
#     evaluate_target_health = false
#   }
# }

# resource "aws_route53_record" "digital_gov_apex_aaaa" {
#   zone_id = aws_route53_zone.digital_toplevel.zone_id
#   name    = "digital.gov."
#   type    = "AAAA"

#   alias {
#     name                   = "d2q1i25any8vwy.cloudfront.net."
#     zone_id                = local.cloud_gov_cloudfront_zone_id
#     evaluate_target_health = false
#   }
# }

# # www.digital.gov — redirects to digital.gov through pages_redirect
resource "aws_route53_record" "digital_gov_www" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "www.digital.gov."
  type    = "A"

  alias {
    name                   = "d11gdxqvugzxkr.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "digital_gov_www_aaaa" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "www.digital.gov."
  type    = "AAAA"

  alias {
    name                   = "d11gdxqvugzxkr.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}



# workflow.digitalgov.gov
# redirects to digital.gov/workflow
#module "digital_gov__workflow_digital_gov_redirect" {
#  source = "mediapop/redirect/aws"
#  version = "1.3.0"

#  domains = {
#    "digital.gov." = ["workflow.digital.gov"]
#  }

#  redirect_to = "https://digital.gov/workflow"
#}

# USWDS - U.S. Web Design System -------------------------------
# designsystem.digital.gov — A
# (Master site in Federalist)
resource "aws_route53_record" "designsystem_digital_gov_a" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "designsystem.digital.gov."
  type    = "A"
  alias {
    name                   = "dlu3fkwowya06.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

# designsystem.digital.gov — AAAA
# (Master site in Federalist)
resource "aws_route53_record" "designsystem_digital_gov_aaaa" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "designsystem.digital.gov."
  type    = "AAAA"
  alias {
    name                   = "dlu3fkwowya06.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

# v2.designsystem.digital.gov — CNAME -------------------------------
# (Redirects to designsystem.digital.gov via WAF)
resource "aws_route53_record" "v2_designsystem_digital_gov_cname" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "v2.designsystem.digital.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["v2.designsystem.digital.gov.external-domains-production.cloud.gov."]
}

# v2.designsystem.digital.gov acme challenge — CNAME -------------------------------
resource "aws_route53_record" "acme_challenge_v2_designsystem_digital_gov_cname" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "_acme-challenge.v2.designsystem.digital.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.v2.designsystem.digital.gov.external-domains-production.cloud.gov."]
}

# v1.designsystem.digital.gov — A -------------------------------
# (DEMO site in Federalist)
resource "aws_route53_record" "v1_designsystem_digital_gov_a" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "v1.designsystem.digital.gov."
  type    = "A"
  alias {
    name                   = "d5bhevr9bklr9.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "v1_designsystem_digital_gov_aaaa" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "v1.designsystem.digital.gov."
  type    = "AAAA"
  alias {
    name                   = "d5bhevr9bklr9.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}



# public-sans.digital.gov — A
resource "aws_route53_record" "public_sans_digital_gov_a" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "public-sans.digital.gov."
  type    = "A"
  alias {
    name                   = "d30jruftdogur6.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "public_sans_digital_gov_aaaa" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "public-sans.digital.gov."
  type    = "AAAA"
  alias {
    name                   = "d30jruftdogur6.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

# accessibility.digital.gov — CNAME -------------------------------
# (Redirects to digital.gov/guides/accessibility-for-teams via WAF)
resource "aws_route53_record" "accessibility_digital_gov_cname" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "accessibility.digital.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["accessibility.digital.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "_acme-challenge_accessibility_digital_gov_cname" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "_acme-challenge.accessibility.digital.gov."
  type    = "CNAME"
  ttl     = 1800
  records = ["_acme-challenge.accessibility.digital.gov.external-domains-production.cloud.gov."]
}

# emerging.digital.gov — CNAME -------------------------------
# (Redirects to digital.gov/topics/emerging-tech via WAF)
resource "aws_route53_record" "emerging_digital_gov_cname" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "emerging.digital.gov."
  type    = "CNAME"
  ttl     = 1800
  records = ["emerging.digital.gov.external-domains-production.cloud.gov."]
}

# _acme-challenge.emerging.digital.gov — CNAME -------------------------------
resource "aws_route53_record" "_acme-challenge_emerging_digital_gov_cname" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "_acme-challenge.emerging.digital.gov."
  type    = "CNAME"
  ttl     = 1800
  records = ["_acme-challenge.emerging.digital.gov.external-domains-production.cloud.gov."]
}

# pra.digital.gov — A -------------------------------
#resource "aws_route53_record" "pra_digital_gov_a" {
#  zone_id = aws_route53_zone.digital_toplevel.zone_id
#  name    = "pra.digital.gov."
#  type    = "A"
#  alias {
#    name                   = "d3vwm5h0acan67.cloudfront.net."
#    zone_id                = local.cloud_gov_cloudfront_zone_id
#    evaluate_target_health = false
#  }
#}

#resource "aws_route53_record" "pra_digital_gov_aaaa" {
#  zone_id = aws_route53_zone.digital_toplevel.zone_id
#  name    = "pra.digital.gov."
#  type    = "AAAA"
#  alias {
#    name                   = "d3vwm5h0acan67.cloudfront.net."
#    zone_id                = local.cloud_gov_cloudfront_zone_id
#    evaluate_target_health = false
#  }
#}


# pra.digital.gov — CNAME -------------------------------
resource "aws_route53_record" "pra_digital_gov_cname" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "pra.digital.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["pra.digital.gov.external-domains-production.cloud.gov."]
}

# pra.digital.gov — CNAME ACME -------------------------------
resource "aws_route53_record" "_acme-challenge_pra_digital_gov_cname" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "_acme-challenge.pra.digital.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.pra.digital.gov.external-domains-production.cloud.gov."]
}

# demo.pra.digital.gov — CNAME -------------------------------
resource "aws_route53_record" "demo_pra_digital_gov_cname" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "demo.pra.digital.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["demo.pra.digital.gov.external-domains-production.cloud.gov."]
}

# demo.pra.digital.gov — CNAME ACME  -------------------------------
resource "aws_route53_record" "_acme-challenge_demo_pra_digital_gov_cname" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "_acme-challenge.demo.pra.digital.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_acme-challenge.demo.pra.digital.gov.external-domains-production.cloud.gov."]
}


# Touchpoints ------------------------------------------------------------------
# A simple, flexible, and convenient way to collect customer feedback.
# Contact feedback-analytics@gsa.gov or digitalgov@gsa.gov

# DEMO Touchpoints Site / Federalist / demo.touchpoints.digital.gov — A
resource "aws_route53_record" "demo_touchpoints_digital_gov_a" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "demo.touchpoints.digital.gov."
  type    = "A"
  alias {
    name                   = "dcxk3q3d8gzx7.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "demo_touchpoints_digital_gov_aaaa" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "demo.touchpoints.digital.gov."
  type    = "AAAA"
  alias {
    name                   = "dcxk3q3d8gzx7.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

# DEMO Touchpoints APP / Amazon SES Verification TXT Record
# demo.touchpoints.digital.gov
resource "aws_route53_record" "demo_touchpoints_digital_gov_verification_txt" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "_amazonses.demo-app.touchpoints.digital.gov"
  type    = "TXT"
  ttl     = "300"
  records = [
    "hzTUt6Q3kaLSAw5VleJgk8Rt7kikHwGMLeZd+QMHSEY="
  ]
}

# DEMO Touchpoints APP / Amazon SES CNAME
# demo-app.touchpoints.digital.gov — CNAME + DKIM 1 of 3
# Proof of ownership over the domain
resource "aws_route53_record" "demo_app_touchpoints_digital_gov_ses_cname_1" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "hg7wfopagu3tgfjnqijxrx7gs34ihjo5._domainkey.demo-app.touchpoints.digital.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["hg7wfopagu3tgfjnqijxrx7gs34ihjo5.dkim.amazonses.com"]
}

# DEMO Touchpoints APP / Amazon SES CNAME for email address feedback-analytics@
# demo-app.touchpoints.digital.gov — CNAME + DKIM 1 of 3
# Proof of ownership over the email address
resource "aws_route53_record" "demo_app_touchpoints_digital_gov_ses_cname_feedback_analytics_1" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "isqdr7f2pc3xk7e47vrh2j2dcuqh26f4._domainkey.gsa.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["isqdr7f2pc3xk7e47vrh2j2dcuqh26f4.dkim.amazonses.com"]
}
resource "aws_route53_record" "demo_app_touchpoints_digital_gov_ses_cname_feedback_analytics_2" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "e3pofe6g2od3r7iz5cb3uuamzqoswivr._domainkey.gsa.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["e3pofe6g2od3r7iz5cb3uuamzqoswivr.dkim.amazonses.com"]
}
resource "aws_route53_record" "demo_app_touchpoints_digital_gov_ses_cname_feedback_analytics_3" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "4cxntmmscgkefitlpux7uuf7qvong7br._domainkey.gsa.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["4cxntmmscgkefitlpux7uuf7qvong7br.dkim.amazonses.com"]
}

# DEMO Touchpoints APP / Amazon SES CNAME
# demo-app.touchpoints.digital.gov — CNAME + DKIM 2 of 3
# Proof of ownership over the domain
resource "aws_route53_record" "demo_app_touchpoints_digital_gov_ses_cname_2" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "6k4bacuvswoo77zsfpgg22c456xkcm2d._domainkey.demo-app.touchpoints.digital.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["6k4bacuvswoo77zsfpgg22c456xkcm2d.dkim.amazonses.com"]
}

# DEMO Touchpoints APP / Amazon SES CNAME
# demo-app.touchpoints.digital.gov — CNAME + DKIM 3 of 3
# Proof of ownership over the domain
resource "aws_route53_record" "demo_app_touchpoints_digital_gov_ses_cname_3" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "frvj7kknqxwqaoypz5w5l54yirxtqeue._domainkey.demo-app.touchpoints.digital.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["frvj7kknqxwqaoypz5w5l54yirxtqeue.dkim.amazonses.com"]
}

# Touchpoints Site / Federalist / touchpoints.digital.gov — A
resource "aws_route53_record" "touchpoints_digital_gov_a" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "touchpoints.digital.gov."
  type    = "A"
  alias {
    name                   = "d5n0pmq4ueiac.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "touchpoints_digital_gov_aaaa" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "touchpoints.digital.gov."
  type    = "AAAA"
  alias {
    name                   = "d5n0pmq4ueiac.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

# Touchpoints APP / Amazon SES Verification TXT Record
# touchpoints.digital.gov
resource "aws_route53_record" "touchpoints_digital_gov_verification_txt" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "_amazonses.app.touchpoints.digital.gov"
  type    = "TXT"
  ttl     = "300"
  records = [
    "r3nlrOyTmleqQm6yXXyHqEffx6FC3vtWnv9UPMhkADw="
  ]
}

# app-staging.touchpoints.digital.gov
resource "aws_route53_record" "app_staging_touchpoints_digital_gov_cname" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "app-staging.touchpoints.digital.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["app-staging.touchpoints.digital.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "app_staging_touchpoints_digital_gov__acme-challenge_cname" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "_acme-challenge.app-staging.touchpoints.digital.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.app-staging.touchpoints.digital.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "app_staging_touchpoints_digital_gov_ses_cname_1" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "stbimes7zj4vgflonbsq6olxg6zizkaf._domainkey.app-staging.touchpoints.digital.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["stbimes7zj4vgflonbsq6olxg6zizkaf.dkim.amazonses.com"]
}

resource "aws_route53_record" "app_staging_touchpoints_digital_gov_ses_cname_2" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "cwgheubcxgxzulqmzqbwvpnrs52scxpp._domainkey.app-staging.touchpoints.digital.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["cwgheubcxgxzulqmzqbwvpnrs52scxpp.dkim.amazonses.com"]
}

resource "aws_route53_record" "app_staging_touchpoints_digital_gov_ses_cname_3" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "rvym6qcpuuxomyqroq73lpy2xqs6vbbk._domainkey.app-staging.touchpoints.digital.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["rvym6qcpuuxomyqroq73lpy2xqs6vbbk.dkim.amazonses.com"]
}

# app-demo.touchpoints.digital.gov
resource "aws_route53_record" "app_demo_touchpoints_digital_gov_cname" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "app-demo.touchpoints.digital.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["app-demo.touchpoints.digital.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "app_demo_touchpoints_digital_gov__acme-challenge_cname" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "_acme-challenge.app-demo.touchpoints.digital.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.app-demo.touchpoints.digital.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "app_demo_touchpoints_digital_gov_ses_cname_1" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "xrbz55v6evbaiet6px6gtg3udbvsslzq._domainkey.app-demo.touchpoints.digital.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["xrbz55v6evbaiet6px6gtg3udbvsslzq.dkim.amazonses.com"]
}

resource "aws_route53_record" "app_demo_touchpoints_digital_gov_ses_cname_2" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "s6klsvu4cxpqdu4itpclpuecwq7ri5vy._domainkey.app-demo.touchpoints.digital.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["s6klsvu4cxpqdu4itpclpuecwq7ri5vy.dkim.amazonses.com"]
}

resource "aws_route53_record" "app_demo_touchpoints_digital_gov_ses_cname_3" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "m6d3etxkxjut3c7bfl5bmzz5biqcjxhe._domainkey.app-demo.touchpoints.digital.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["m6d3etxkxjut3c7bfl5bmzz5biqcjxhe.dkim.amazonses.com"]
}

# Application endpoint for app.touchpoints.digital.gov - keep this as is
resource "aws_route53_record" "app_touchpoints_digital_gov_cname" {
  zone_id         = aws_route53_zone.digital_toplevel.zone_id
  name            = "app.touchpoints.digital.gov."
  type            = "CNAME"
  ttl             = 120
  allow_overwrite = true
  records         = ["app.touchpoints.digital.gov.external-domains-production.cloud.gov."]

  lifecycle {
    prevent_destroy = true
  }
}

# Add SPF record for mail subdomain
resource "aws_route53_record" "app_touchpoints_digital_gov_spf" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "_acme-challenge.app.touchpoints.digital.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.app.touchpoints.digital.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "app_touchpoints_digital_gov_ses_cname_1" {
  zone_id         = aws_route53_zone.digital_toplevel.zone_id
  name            = "qqtoqzlc5a24irzufsu4lbdpoc3mvr3n._domainkey.app.touchpoints.digital.gov"
  type            = "CNAME"
  ttl             = 1800
  allow_overwrite = true  # Add this to handle conflicts
  records         = ["qqtoqzlc5a24irzufsu4lbdpoc3mvr3n.dkim.amazonses.com"]
}

resource "aws_route53_record" "app_touchpoints_digital_gov_ses_cname_2" {
  zone_id         = aws_route53_zone.digital_toplevel.zone_id
  name            = "4dh5jgv5chdo2q3axkftnini7j7xkdjx._domainkey.app.touchpoints.digital.gov"
  type            = "CNAME"
  ttl             = 1800
  allow_overwrite = true  # Add this to handle conflicts
  records         = ["4dh5jgv5chdo2q3axkftnini7j7xkdjx.dkim.amazonses.com"]
}

resource "aws_route53_record" "app_touchpoints_digital_gov_ses_cname_3" {
  zone_id         = aws_route53_zone.digital_toplevel.zone_id
  name            = "pwa5cvp3cde3aghrojag7ketcjaeytp2._domainkey.app.touchpoints.digital.gov"
  type            = "CNAME"
  ttl             = 1800
  allow_overwrite = true  # Add this to handle conflicts
  records         = ["pwa5cvp3cde3aghrojag7ketcjaeytp2.dkim.amazonses.com"]
}

# Mail records moved to mail subdomain
resource "aws_route53_record" "mail_touchpoints_digital_gov_mx" {
  zone_id         = aws_route53_zone.digital_toplevel.zone_id
  name            = "mail.touchpoints.digital.gov."  # Mail subdomain for general email
  type            = "MX"
  ttl             = "600"
  allow_overwrite = true
  records         = [
    "10 inbound-smtp.us-east-1.amazonaws.com"
  ]

  lifecycle {
    prevent_destroy = true
  }
}

# Touchpoints Staging APP / Amazon SES Verification TXT Record
resource "aws_route53_record" "touchpoints_staging_aws_ses" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "_amazonses.touchpoints-staging.app.cloud.gov"
  type    = "TXT"
  ttl     = 120
  records = [
    "FCYaHGmDC96KOetecQ23s3gKA6Z7TJ6PNQATBQmLPM8="
  ]
}

# Touchpoints Staging APP / 3 cnames to enable DKIM for Amazon SES -------------
# DKIM 1 of 3
resource "aws_route53_record" "touchpoints_staging_digital_gov_ses_cname_1" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "26hqif4fsgvtyuqksytfsw5pjb22xoxj._domainkey.touchpoints-staging.app.cloud.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["26hqif4fsgvtyuqksytfsw5pjb22xoxj.dkim.amazonses.com"]
}

# DKIM 2 of 3
resource "aws_route53_record" "touchpoints_staging_digital_gov_ses_cname_2" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "vceeiyemjswgbeegriak3wci7gnvxg2v._domainkey.touchpoints-staging.app.cloud.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["vceeiyemjswgbeegriak3wci7gnvxg2v.dkim.amazonses.com"]
}

# DKIM 3 of 3
resource "aws_route53_record" "touchpoints_staging_digital_gov_ses_cname_3" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "w5yzy55zindfay2hlzgzj7znigctbpyb._domainkey.touchpoints-staging.app.cloud.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["w5yzy55zindfay2hlzgzj7znigctbpyb.dkim.amazonses.com"]
}

# Touchpoints APP / 3 cnames to enable DKIM for Amazon SES ---------------------
# DKIM 1 of 3
resource "aws_route53_record" "touchpoints_digital_gov_ses_cname_1" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "qqtoqzlc5a24irzufsu4lbdpoc3mvr3n._domainkey.app.touchpoints.digital.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["qqtoqzlc5a24irzufsu4lbdpoc3mvr3n.dkim.amazonses.com"]
}

# Touchpoints APP / Amazon SES CNAME
# DKIM 2 of 3
resource "aws_route53_record" "touchpoints_digital_gov_ses_cname_2" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "4dh5jgv5chdo2q3axkftnini7j7xkdjx._domainkey.app.touchpoints.digital.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["4dh5jgv5chdo2q3axkftnini7j7xkdjx.dkim.amazonses.com"]
}

# Touchpoints APP / Amazon SES CNAME
# DKIM 3 of 3
resource "aws_route53_record" "touchpoints_digital_gov_ses_cname_3" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "pwa5cvp3cde3aghrojag7ketcjaeytp2._domainkey.app.touchpoints.digital.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["pwa5cvp3cde3aghrojag7ketcjaeytp2.dkim.amazonses.com"]
}

resource "aws_route53_record" "touchpoints_digital_gov_dkim_1" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "q7e7jvcl23omte4fum6jgp5lpwgxdp7a._domainkey.touchpoints.digital.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["q7e7jvcl23omte4fum6jgp5lpwgxdp7a.dkim.amazonses.com"]
}

resource "aws_route53_record" "touchpoints_digital_gov_dkim_2" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "y5bm3fsnhjdr5ar2qwyneeiy7wr5c64e._domainkey.touchpoints.digital.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["y5bm3fsnhjdr5ar2qwyneeiy7wr5c64e.dkim.amazonses.com"]
}

resource "aws_route53_record" "touchpoints_digital_gov_dkim_3" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "anyljchthsaitorr6matbfeoeyug34jh._domainkey.touchpoints.digital.gov"
  type    = "CNAME"
  ttl     = 1800
  records = ["anyljchthsaitorr6matbfeoeyug34jh.dkim.amazonses.com"]
}

# Touchpoints APP / MX Records
# app.touchpoints.digital.gov
resource "aws_route53_record" "app_touchpoints_digital_gov_mx" {
  zone_id         = aws_route53_zone.digital_toplevel.zone_id
  name            = "app.touchpoints.digital.gov."  # App-specific email handling
  type            = "MX"
  ttl             = "600"
  allow_overwrite = true
  records         = [
    "10 inbound-smtp.us-east-1.amazonaws.com"
  ]

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "mail_from_touchpoints_digital_gov_mx" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "mail.touchpoints.digital.gov"
  type    = "MX"
  ttl     = "600"
  records = [
    "10 feedback-smtp.us-east-1.amazonses.com"
  ]
}

resource "aws_route53_record" "touchpoints_digital_gov_spf" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name = "mail.touchpoints.digital.gov"
  type = "TXT"
  ttl = 600
  records = ["v=spf1 include:amazonses.com ~all"]
}

# Compliance and ACME records -------------------------------

module "digital_gov__email_security" {
  source = "./email_security"

  zone_id = aws_route53_zone.digital_toplevel.zone_id
  txt_records = [
    "google-site-verification=Mi2rwVMxdp3eSbZughKvN0M_dwi6WLxMrRSsnLOWyVI",
    local.spf_hubspot
  ]
}

# pra.digital.gov TXT / ACME Challenge
#resource "aws_route53_record" "pra_digital_gov__acme-challenge_txt" {
#  zone_id = aws_route53_zone.digital_toplevel.zone_id
#  name    = "_acme-challenge.pra.digital.gov."
#  type    = "TXT"
#  ttl     = 120
#  records = ["0VxlpUbA2CXBDx1GKUlr-SujwU0ep9KvGrM0BvE6o4E"]
#}

# demo.touchpoints.digital.gov TXT / ACME Challenge
resource "aws_route53_record" "demo_touchpoints_digital_gov__acme-challenge_txt" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "_acme-challenge.demo.touchpoints.digital.gov."
  type    = "TXT"
  ttl     = 120
  records = ["n77f2RwJfGyS0NuSm-qIaf0FZEEURhqEACLML32hV0Y"]
}

# touchpoints.digital.gov TXT / ACME Challenge
resource "aws_route53_record" "touchpoints_digital_gov__acme-challenge_txt" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "_acme-challenge.touchpoints.digital.gov."
  type    = "TXT"
  ttl     = 120
  records = ["Ho5lFIaJK7J44nLyBWGpfMBRNc96eL7-QnMuBII-4Uc"]
}

# standards.digital.gov — CNAME -------------------------------
# (Redirects to standards.digital.gov via "pages redirect")
resource "aws_route53_record" "standards_digital_gov_cname" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "standards.digital.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["standards.digital.gov.external-domains-production.cloud.gov."]
}

# standards.digital.gov — CNAME -------------------------------
# (Redirects to standards.digital.gov via "pages redirect")
resource "aws_route53_record" "_acme-challenge_standards_digital_gov_cname" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "_acme-challenge.standards.digital.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.standards.digital.gov.external-domains-production.cloud.gov."]
}

# =================================

# EMAIL NEWSLETTER (HubSpot)

# Hubspot records for sending email from the digital.gov domain
resource "aws_route53_record" "hubspot1_digital_gov_a" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "hs1._domainkey.digital.gov."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "digital-gov.hs01a.dkim.hubspotemail.net."
  ]
}

# Hubspot records for sending email from the digital.gov domain
resource "aws_route53_record" "hubspot2_digital_gov_a" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "hs2._domainkey.digital.gov."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "digital-gov.hs01b.dkim.hubspotemail.net."
  ]
}

# Hubspot TXT records for sending email from the digital.gov domain
resource "aws_route53_record" "hubspot_digital_gov_txt" {
  zone_id = aws_route53_zone.digital_toplevel.zone_id
  name    = "smtpapi._domainkey.digital.gov."
  type    = "TXT"
  ttl     = "300"
  records = [
    "k=rsa; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDPtW5iwpXVPiH5FzJ7Nrl8USzuY9zqqzjE0D1r04xDN6qwziDnmgcFNNfMewVKN2D1O+2J9N14hRprzByFwfQW76yojh54Xu3uSbQ3JP0A7k8o8GutRF8zbFUA8n0ZH2y0cIEjMliXY4W4LwPA7m4q0ObmvSjhd63O9d8z1XkUBwIDAQAB"
  ]
}

# END EMAIL NEWSLETTER (HubSpot)

# =================================

output "digital_ns" {
  value = aws_route53_zone.digital_toplevel.name_servers
}

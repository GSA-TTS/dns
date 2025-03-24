resource "aws_route53_zone" "d_18f_gov_zone" {
  name = "18f.gov."

  tags = {
    Project = "dns"
  }
}

resource "aws_route53_record" "d_18f_gov_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "18f.gov."
  type    = "A"

  alias {
    name                   = "d1undivnru8ry9.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d1undivnru8ry9.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_github_18f_gov_txt" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_github-challenge-18F.18f.gov"
  type    = "TXT"
  ttl     = 300
  records = ["606c521d44"]
}

module "d_18f_gov__email_security" {
  source  = "./email_security"
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  txt_records = [
    local.spf_no_mail,
    "google-site-verification=HwR6BJFZpjma0wYRYRejCxvOSDuE_tycmgV2_h6y_TA"
  ]
}

resource "aws_route53_record" "d_18f_gov__acme-challenge_18f_gov_txt" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.18f.gov."
  type    = "TXT"
  ttl     = 300
  records = ["pEkgOBDXa7LJqQhnniOe_AIN1tgSObw3kX6y32t34sA"]
}

resource "aws_route53_record" "d_18f_gov_01326251e4e9fc611488dd6bceaeba90_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "01326251e4e9fc611488dd6bceaeba90.18f.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["bf0db5e895e580832a39b4e0eff83874dc595c73.comodoca.com."]
}

resource "aws_route53_record" "d_18f_gov_4977f4aa788de0a5daa860d9fc0215a5_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "4977f4aa788de0a5daa860d9fc0215a5.18f.gov."
  type    = "CNAME"
  ttl     = 5
  records = ["7573d58626148c30b5d2fbf1dd7bf7a302f23e4e.comodoca.com."]
}

resource "aws_route53_record" "d_18f_gov_89afa0142502f9be9fba3afd80a703e1_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "89afa0142502f9be9fba3afd80a703e1.18f.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["11c866ad428c34fc9aa545123e72ef879b0898ef.comodoca.com."]
}

# Individual site records start here, alphabetized by subdomain name

# accessibility.18f.gov acme challenge — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov__acme_challenge_accessibility_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.accessibility.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.accessibility.18f.gov.external-domains-production.cloud.gov."]
}

# accessibility.18f.gov — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov_accessibility_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "accessibility.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["accessibility.18f.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "d_18f_gov_ads_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "ads.18f.gov."
  type    = "A"

  alias {
    name                   = "d22116wmhcds2y.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_ads_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "ads.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d22116wmhcds2y.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov__acme-challenge_ads_18f_gov_txt" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.ads.18f.gov."
  type    = "TXT"
  ttl     = 120
  records = ["fXfES1KVPHxh87Y9iMVwl_ezEGRpKagAL7EzQpuYaBI"]
}

resource "aws_route53_record" "d_18f_gov__acme_challenge_agile_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.agile.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.agile.18f.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "d_18f_gov_agile_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "agile.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["agile.18f.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "d_18f_gov__acme_challenge_agile-labor-categories_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.agile-labor-categories.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.agile-labor-categories.18f.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "d_18f_gov_agile-labor-categories_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "agile-labor-categories.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["agile-labor-categories.18f.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "d_18f_gov_api_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "api.18f.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["18f.domains.api.data.gov"]
}

resource "aws_route53_record" "d_18f_gov_acqstack-journeymap_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "acqstack-journeymap.18f.gov."
  type    = "A"

  alias {
    name                   = "douocfsg4z7b4.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_acqstack-journeymap_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "acqstack-journeymap.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "douocfsg4z7b4.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov__acme-challenge_acqstack_journeymap_18f_gov_txt" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.acqstack-journeymap.18f.gov."
  type    = "TXT"
  ttl     = 120
  records = ["m6cdUen5P3H9ESqtXwatoTxbGf4klo6aSddvoF8Cc_A"]
}

resource "aws_route53_record" "d_18f_gov_api-all-the-x_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "api-all-the-x.18f.gov."
  type    = "A"

  alias {
    name                   = "d2y8d8116udf0m.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_api-all-the-x_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "api-all-the-x.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d2y8d8116udf0m.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_api-program_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "api-program.18f.gov."
  type    = "A"

  alias {
    name                   = "d1evjsspb8gisi.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_api-program_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "api-program.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d1evjsspb8gisi.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_api-usability-testing_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "api-usability-testing.18f.gov."
  type    = "A"

  alias {
    name                   = "d1lsalt1zbpjfm.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_api-usability-testing_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "api-usability-testing.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d1lsalt1zbpjfm.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov__acme_challenge_atf-eregs_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.atf-eregs.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.atf-eregs.18f.gov.external-domains-production.cloud.gov."]
}

# resource "aws_route53_record" "d_18f_gov_atf-eregs_18f_gov_cname" {
#   zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
#   name    = "atf-eregs.18f.gov."
#   type    = "CNAME"
#   ttl     = 300
#   records = ["d1a8iv0i0iazmn.cloudfront.net"]
# }

resource "aws_route53_record" "d_18f_gov_atf-eregs_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "atf-eregs.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["atf-eregs.18f.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "d_18f_gov_atul-docker-presentation_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "atul-docker-presentation.18f.gov."
  type    = "A"

  alias {
    name                   = "dndsei0n82g4z.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_autoapi_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "autoapi.18f.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["d31k5ro0ea9ojq.cloudfront.net"]
}

resource "aws_route53_record" "d_18f_gov_automated-testing-playbook_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "automated-testing-playbook.18f.gov."
  type    = "A"

  alias {
    name                   = "dieiwe9bk9l6.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_automated-testing-playbook_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "automated-testing-playbook.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "dieiwe9bk9l6.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_blogging-guide_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "blogging-guide.18f.gov."
  type    = "A"

  alias {
    name                   = "d12gmeaikmi2zi.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_blogging-guide_18f_gov_cname_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "blogging-guide.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d12gmeaikmi2zi.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_before-you-ship_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "before-you-ship.18f.gov."
  type    = "A"

  alias {
    name                   = "daap61vtgsw76.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_before-you-ship_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "before-you-ship.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "daap61vtgsw76.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_boise_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "boise.18f.gov."
  type    = "A"

  alias {
    name                   = "d2swak4c9i5bze.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_boise_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "boise.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d2swak4c9i5bze.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov__acme-challenge_boise_18f_gov_txt" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.boise.18f.gov."
  type    = "TXT"
  ttl     = 120
  records = ["wtVQL98OnnahVdqneIGLrHfMAD30e7JWDOFouTenqaM"]
}

# brand.18f.gov acme challenge — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov__acme_challenge_brand_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.brand.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.brand.18f.gov.external-domains-production.cloud.gov."]
}

# brand.18f.gov — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov_brand_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "brand.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["brand.18f.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "d_18f_gov_c6769c03c29466618a6bd23b158d28a6_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "c6769c03c29466618a6bd23b158d28a6.18f.gov."
  type    = "CNAME"
  ttl     = 5
  records = ["25dcca43a0e035f9109366532ca4bea5a552e1ba.comodoca.com."]
}

resource "aws_route53_record" "d_18f_gov_charlie_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "charlie.18f.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["d30i8aauyor9vc.cloudfront.net"]
}

# content-guide.18f.gov acme challenge — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov__acme_challenge_content-guide_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.content-guide.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.content-guide.18f.gov.external-domains-production.cloud.gov."]
}

# content-guide.18f.gov — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov_content-guide_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "content-guide.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["content-guide.18f.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "d_18f_gov_contracting-cookbook_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "contracting-cookbook.18f.gov."
  type    = "A"

  alias {
    name                   = "d20pvyni7jlo89.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_contracting-cookbook_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "contracting-cookbook.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d20pvyni7jlo89.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_continua11y_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "continua11y.18f.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["dwz1sfldhro5q.cloudfront.net"]
}

resource "aws_route53_record" "d_18f_gov_design-principles-guide_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "design-principles-guide.18f.gov."
  type    = "A"

  alias {
    name                   = "d3g58t13quzfbr.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_design-principles-guide_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "design-principles-guide.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d3g58t13quzfbr.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_digital-acquisition-playbook_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "digital-acquisition-playbook.18f.gov."
  type    = "A"

  alias {
    name                   = "d3f32ju5qz0fej.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_digital-acquisition-playbook_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "digital-acquisition-playbook.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d3f32ju5qz0fej.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_digitalaccelerator_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "digitalaccelerator.18f.gov."
  type    = "A"

  alias {
    name                   = "dmsaspwnb8oe8.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_digitalaccelerator_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "digitalaccelerator.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "dmsaspwnb8oe8.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}


# eng-hiring.18f.gov acme challenge — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov__acme_challenge_eng-hiring_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.eng-hiring.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.eng-hiring.18f.gov.external-domains-production.cloud.gov."]
}

# eng-hiring.18f.gov — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov_eng-hiring_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "eng-hiring.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["eng-hiring.18f.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "d_18f_gov_federalist_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "federalist.18f.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["federalist.18f.gov.external-domains-production.cloud.gov"]
}

resource "aws_route53_record" "d_18f_gov_acme_challenge_federalist_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.federalist.18f.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["_acme-challenge.federalist.18f.gov.external-domains-production.cloud.gov"]
}

resource "aws_route53_record" "d_18f_gov_federalistapp_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "federalistapp.18f.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["federalistapp.18f.gov.external-domains-production.cloud.gov"]
}

resource "aws_route53_record" "d_18f_gov_acme_challenge_federalistapp_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.federalistapp.18f.gov."
  type    = "CNAME"
  ttl     = 60
  records = ["_acme-challenge.federalistapp.18f.gov.external-domains-production.cloud.gov"]
}

resource "aws_route53_record" "d_18f_gov_files_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "files.18f.gov."
  type    = "A"

  alias {
    name                   = "d3gawctq7ecsbu.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_fugacious_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "fugacious.18f.gov."
  type    = "A"

  alias {
    name                   = "d309sw0ah4sgku.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_fugacious_18f_gov_txt" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "fugacious.18f.gov."
  type    = "TXT"
  ttl     = 300
  records = ["d309sw0ah4sgku.cloudfront.net."]
}

# govconnect.18f.gov — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov_govconnect_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "govconnect.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["govconnect.18f.gov.external-domains-production.cloud.gov."]
}

# govconnect.18f.gov acme challenge — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov__acme_challenge_govconnect_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.govconnect.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.govconnect.18f.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "d_18f_gov_grouplet-playbook_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "grouplet-playbook.18f.gov."
  type    = "A"

  alias {
    name                   = "duek7xmosg5g1.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_grouplet-playbook_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "grouplet-playbook.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "duek7xmosg5g1.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

# guides.18f.gov — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov_guides_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "guides.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["guides.18f.gov.external-domains-production.cloud.gov."]
}

# guides.18f.gov acme challenge — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov__acme_challenge_guides_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.guides.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.guides.18f.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "d_18f_gov_guides-template_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "guides-template.18f.gov."
  type    = "A"

  alias {
    name                   = "d2qsfvvx1xjk0n.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_guides-template_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "guides-template.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d2qsfvvx1xjk0n.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_iaa-forms_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "iaa-forms.18f.gov."
  type    = "A"

  alias {
    name                   = "d25t6p0vmr5bdy.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_iaa-forms_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "iaa-forms.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d25t6p0vmr5bdy.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_innovation-toolkit-prototype_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "innovation-toolkit-prototype.18f.gov."
  type    = "A"

  alias {
    name                   = "d1n516riijd335.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_innovation-toolkit-prototype_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "innovation-toolkit-prototype.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d1n516riijd335.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

#module "d_18f_gov__join_18f_gov_redirect" {
#  source  = "mediapop/redirect/aws"
#  version = "1.2.1"

#  domains = {
#    "18f.gov." = ["jobs.18f.gov", "join.18f.gov"]
#  }
#
#  redirect_to = "https://18f.gsa.gov/join"
#}

resource "aws_route53_record" "d_18f_gov_lean-product-design_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "lean-product-design.18f.gov."
  type    = "A"

  alias {
    name                   = "d3am6kz2e8wzjv.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_lean-product-design_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "lean-product-design.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d3am6kz2e8wzjv.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

# methods.18f.gov — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov_methods_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "methods.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["methods.18f.gov.external-domains-production.cloud.gov."]
}


# acme challenge methods.18f.gov — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov__acme_challenge_methods_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.methods.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.methods.18f.gov.external-domains-production.cloud.gov."]
}


# Configured with CDN Broker
resource "aws_route53_record" "d_18f_gov_micropurchase_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "micropurchase.18f.gov."
  type    = "A"

  alias {
    name                   = "dh692qtc0b17x.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_micropurchase_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "micropurchase.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "dh692qtc0b17x.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov__acme-challenge_micropurchase_18f_gov_txt" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.micropurchase.18f.gov."
  type    = "TXT"
  ttl     = 120
  records = ["_aw_jMfmFuXZEje_N7_iPC25eqymsMzE9fQ5l7dN1o0"]
}

resource "aws_route53_record" "d_18f_gov_open-source-guide_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "open-source-guide.18f.gov."
  type    = "A"

  alias {
    name                   = "d1lphbkymflb0f.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_open-source-guide_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "open-source-guide.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d1lphbkymflb0f.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_open-source-program_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "open-source-program.18f.gov."
  type    = "A"

  alias {
    name                   = "d3nhr6mr0xvquu.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_open-source-program_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "open-source-program.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d3nhr6mr0xvquu.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_pages_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "pages.18f.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["dvtze1xj8nrwl.cloudfront.net"]
}

resource "aws_route53_record" "d_18f_gov_paid-leave-prototype_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "paid-leave-prototype.18f.gov."
  type    = "A"

  alias {
    name                   = "d3p6d6b3zaatqv.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_paid-leave-prototype_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "paid-leave-prototype.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d3p6d6b3zaatqv.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov__acme-challenge_paid_leave_prototype_18f_gov_txt" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.paid-leave-prototype.18f.gov."
  type    = "TXT"
  ttl     = 120
  records = ["Rll4MS51zYr9CmfUEjs-0G5HExXnuQiyM_8MBjskIuw"]
}

resource "aws_route53_record" "d_18f_gov_partnership-playbook_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "partnership-playbook.18f.gov."
  type    = "A"

  alias {
    name                   = "d19eih1husc7rz.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_partnership-playbook_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "partnership-playbook.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d19eih1husc7rz.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_plain-language-tutorial_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "plain-language-tutorial.18f.gov."
  type    = "A"

  alias {
    name                   = "d1cr44lbvuvjia.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_plain-language-tutorial_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "plain-language-tutorial.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d1cr44lbvuvjia.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov__acme_challenge_private-eye_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.private-eye.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.private-eye.18f.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "d_18f_gov_private-eye_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "private-eye.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["private-eye.18f.gov.external-domains-production.cloud.gov."]
}


# product-guide.18f.gov acme challenge — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov__acme_challenge_product-guide_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.product-guide.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.product-guide.18f.gov.external-domains-production.cloud.gov."]
}

# product-guide.18f.gov — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov_product-guide_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "product-guide.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["product-guide.18f.gov.external-domains-production.cloud.gov."]
}
resource "aws_route53_record" "d_18f_gov_testing-cookbook_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "testing-cookbook.18f.gov."
  type    = "A"

  alias {
    name                   = "d3r30wgm96hxdb.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_testing-cookbook_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "testing-cookbook.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d3r30wgm96hxdb.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_writing-lab-guide_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "writing-lab-guide.18f.gov."
  type    = "A"

  alias {
    name                   = "d1pjk83agbp9qr.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_writing-lab-guide_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "writing-lab-guide.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d1pjk83agbp9qr.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_www_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "www.18f.gov."
  type    = "A"

  alias {
    name                   = "d1undivnru8ry9.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_www_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "www.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d1undivnru8ry9.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_74f23ac1efe88323e0ec84b56921077e_www_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "74f23ac1efe88323e0ec84b56921077e.www.18f.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["88b7d18d8d24e3b6d539ea7ecbbf719f8af14e5a.comodoca.com."]
}

resource "aws_route53_record" "d_18f_gov_e2e080f495caf881194dadb62fb3d5bc_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "e2e080f495caf881194dadb62fb3d5bc.18f.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["25aad757d26409f9b764f267283fda0ec6e8e3f1.comodoca.com."]
}

resource "aws_route53_record" "d_18f_gov_modularcontracting_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "modularcontracting.18f.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["production-domains-1-884689640.us-gov-west-1.elb.amazonaws.com."]
}

resource "aws_route53_record" "d_18f_gov_agile-bpa_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "agile-bpa.18f.gov."
  type    = "A"

  alias {
    name                   = "d2f0yvhrnh42o8.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_agile-bpa_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "agile-bpa.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d2f0yvhrnh42o8.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov__acme-challenge_agile_bpa_18f_gov_txt" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.agile-bpa.18f.gov."
  type    = "TXT"
  ttl     = 120
  records = ["z29hjtu22N5Ex-cDx8kAwKgP6tDrxdobanSPUtlkZo4"]
}

resource "aws_route53_record" "d_18f_gov_fedspendingtransparency_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "fedspendingtransparency.18f.gov."
  type    = "A"

  alias {
    name                   = "d3fi39fc24yqlx.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_fedspendingtransparency_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "fedspendingtransparency.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d3fi39fc24yqlx.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov__acme-challenge_fedspendingtransparency_18f_gov_txt" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.fedspendingtransparency.18f.gov."
  type    = "TXT"
  ttl     = 120
  records = ["66CqBe0jeCgcnThiCHQi4r2HB9Kv0ucrvifGeWV_jhs"]
}

resource "aws_route53_record" "d_18f_gov_slides_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "slides.18f.gov."
  type    = "A"

  alias {
    name                   = "d1g4r1oppplum4.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_slides_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "slides.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d1g4r1oppplum4.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov__acme-challenge_slides_18f_gov_txt" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.slides.18f.gov."
  type    = "TXT"
  ttl     = 120
  records = ["Ij5FclXKU_n8jvVITVWMnBJsMfpVLTaiaV2xi54x31o"]
}

# engineering.18f.gov acme challenge — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov__acme_challenge_engineering_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.engineering.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.engineering.18f.gov.external-domains-production.cloud.gov."]
}

# engineering.18f.gov — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov_engineering_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "engineering.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["engineering.18f.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "d_18f_gov__acme_challenge_handbook_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.handbook.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.handbook.18f.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "d_18f_gov_handbook_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "handbook.18f.gov."
  type    = "A"

  alias {
    name                   = "d36dwgrf0cle4t.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_handbook_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "handbook.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d36dwgrf0cle4t.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov__acme_challenge_wwwhandbook_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.wwwhandbook.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.wwwhandbook.18f.gov.external-domains-production.cloud.gov."]
}

resource "aws_route53_record" "d_18f_gov_wwwhandbook_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "wwwhandbook.18f.gov."
  type    = "A"

  alias {
    name                   = "d36dwgrf0cle4t.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_wwwhandbook_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "wwwhandbook.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d36dwgrf0cle4t.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_sites-staging_federalist_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_a97eaf263ff636e68fe4c2f55cc71a5b.sites-staging.federalist.18f.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["_d3b212a2d4fdd3f6f9abae5a0a185575.tfmgdnztqk.acm-validations.aws."]
}

resource "aws_route53_record" "d_18f_gov_sites-staging_federalist_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "*.sites-staging.federalist.18f.gov."
  type    = "A"

  alias {
    name                   = "d2826r6t5bqji9.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_sites-staging_federalist_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "*.sites-staging.federalist.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "d2826r6t5bqji9.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_frontend_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "frontend.18f.gov."
  type    = "A"

  alias {
    name                   = "degmwhx2dki4o.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_frontend_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "frontend.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "degmwhx2dki4o.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov__acme-challenge_frontend_18f_gov_txt" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.frontend.18f.gov."
  type    = "TXT"
  ttl     = 120
  records = ["z3yABv7AvSVzev3bjUOCViDXGmeVLrrr2dMdzODOJk8"]
}

resource "aws_route53_record" "d_18f_gov_demo-er2epz2vb_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "demo-er2epz2vb.18f.gov."
  type    = "A"

  alias {
    name                   = "djut57wuzit2q.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov_demo-er2epz2vb_18f_gov_aaaa" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "demo-er2epz2vb.18f.gov."
  type    = "AAAA"

  alias {
    name                   = "djut57wuzit2q.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov__acme-challenge_demo-er2epz2vb_18f_gov_txt" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.demo-er2epz2vb.18f.gov."
  type    = "TXT"
  ttl     = 120
  records = ["AyKIGRjcXOlJjt6A8rRDYAxLp9YPw4B-7nnBiuLKZkg"]
}

resource "aws_route53_record" "d_18f_gov_federalist-proxysite-test_18f_gov_a" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "federalist-proxysite-test.18f.gov."
  type    = "A"

  alias {
    name                   = "d1p5ay1q619hg3.cloudfront.net."
    zone_id                = local.cloud_gov_cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "d_18f_gov__acme-challenge_federalist-proxysite-test_18f_gov_txt" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.federalist-proxysite-test.18f.gov."
  type    = "TXT"
  ttl     = 120
  records = ["qiz18V0W9mHROFHTHqE4_Bn8NIByqMhoLvkKQ3h4Zxg"]
}

# ux-guide.18f.gov acme challenge — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov__acme_challenge_ux-guide_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.ux-guide.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.ux-guide.18f.gov.external-domains-production.cloud.gov."]
}

# ux-guide.18f.gov — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov_ux-guide_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "ux-guide.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["ux-guide.18f.gov.external-domains-production.cloud.gov."]
}

# portfolios.18f.gov — CNAME -------------------------------
# step 1 of https://cloud.gov/docs/services/external-domain-service/#how-to-create-an-instance-of-this-service
resource "aws_route53_record" "d_18f_gov_portfolios_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "portfolios.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["portfolios.18f.gov.external-domains-production.cloud.gov."]
}

# portfolios.18f.gov acme challenge — CNAME -------------------------------
# step 2 of https://cloud.gov/docs/services/external-domain-service/#how-to-create-an-instance-of-this-service
resource "aws_route53_record" "d_18f_gov__acme_challenge_portfolios_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.portfolios.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.portfolios.18f.gov.external-domains-production.cloud.gov."]
}

# derisking-guide.18f.gov — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov_derisking_guide_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "derisking-guide.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["derisking-guide.18f.gov.external-domains-production.cloud.gov."]
}

# derisking-guide.18f.gov acme challenge — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov__acme_challenge_derisking_guide_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.derisking-guide.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.derisking-guide.18f.gov.external-domains-production.cloud.gov."]
}

# federalist-test-site.18f.gov — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov_federalist_test_site_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "federalist-test-site.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["federalist-test-site.18f.gov.external-domains-production.cloud.gov."]
}

# federalist-test-site.18f.gov acme challenge — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov__acme_challenge_federalist_test_site_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.federalist-test-site.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.federalist-test-site.18f.gov.external-domains-production.cloud.gov."]
}

# climate-data-user-study.18f.gov — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov_climate_data_user_study_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "climate-data-user-study.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["climate-data-user-study.18f.gov.external-domains-production.cloud.gov."]
}

# climate-data-user-study.18f.gov acme challenge — CNAME -------------------------------
resource "aws_route53_record" "d_18f_gov__acme_challenge_climate_data_user_study_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.climate-data-user-study.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.climate-data-user-study.18f.gov.external-domains-production.cloud.gov."]
}

output "d_18f_gov_ns" {
  value = aws_route53_zone.d_18f_gov_zone.name_servers
}

# queues.federalistapp.18f.gov - CNAME -----------------
resource "aws_route53_record" "d_18f_gov_queues_federalistapp_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "queues.federalistapp.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["queues.federalistapp.18f.gov.external-domains-production.cloud.gov."]
}

# _acme-challenge.queues.federalistapp.18f.gov acme challenge — CNAME -
resource "aws_route53_record" "d_18f_gov__acme_challenge_queues_federalistapp_18f_gov_cname" {
  zone_id = aws_route53_zone.d_18f_gov_zone.zone_id
  name    = "_acme-challenge.queues.federalistapp.18f.gov."
  type    = "CNAME"
  ttl     = 120
  records = ["_acme-challenge.queues.federalistapp.18f.gov.external-domains-production.cloud.gov."]
}

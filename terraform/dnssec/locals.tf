locals {
  ds_record    = tolist(["DS", var.zone.name, aws_route53_key_signing_key.dnssec_key_signing_key.ds_record])
}

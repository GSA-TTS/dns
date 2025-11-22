output "ds_record" {
  depends_on = [
    aws_route53_hosted_zone_dnssec.dnssec_hosted_zone_dnssec
  ]
  value = [
    local.ds_record
  ]
}

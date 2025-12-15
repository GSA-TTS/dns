# Route53 hosted zone ID for CloudFront distributions
# see https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/aws-properties-route53-recordset-aliastarget.html#cfn-route53-recordset-aliastarget-hostedzoneid
locals {
  cloudfront_zone_id = "Z2FDTNDATAQYW2"
}

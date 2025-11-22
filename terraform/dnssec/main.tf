# Create a KMS key for DNSSEC signing
resource "aws_kms_key" "dnssec_kms_key" {

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
resource "aws_kms_alias" "dnssec_kms_alias" {
  name          = "alias/DNSSEC-${replace(var.zone.name, "/[^a-zA-Z0-9:/_-]/", "-")}"
  target_key_id = aws_kms_key.dnssec_kms_key.key_id
}

resource "aws_route53_key_signing_key" "dnssec_key_signing_key" {
  hosted_zone_id             = var.zone.id
  key_management_service_arn = aws_kms_key.dnssec_kms_key.arn
  name                       = var.zone.name
}

resource "aws_route53_hosted_zone_dnssec" "dnssec_hosted_zone_dnssec" {
  depends_on = [
    aws_route53_key_signing_key.dnssec_key_signing_key
  ]
  hosted_zone_id = aws_route53_key_signing_key.dnssec_key_signing_key.hosted_zone_id
}
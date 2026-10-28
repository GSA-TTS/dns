resource "aws_s3_bucket" "backend" {
  bucket = "tts-dns-terraform-state"

  versioning {
    enabled = true
  }

  # Adding server side encryption with AWS KMS
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3_encryption_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  # Adding lifecycle configuration
  lifecycle_rule {
    id      = "state-files"
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      days = 914
    }
  }

  # Enable access logging
  logging {
    target_bucket = aws_s3_bucket.access_logs.id
    target_prefix = "log/backend-state-bucket/"
  }

  # Setup cross-region replication
  replication_configuration {
    role = aws_iam_role.replication.arn

    rules {
      id     = "state-replication"
      status = "Enabled"
      destination {
        bucket        = aws_s3_bucket.backend_replica.arn
        storage_class = "STANDARD"
      }
    }
  }

  tags = {
    Name    = "terraform-state"
    Project = "dns"
  }
}

# Create bucket for access logs
resource "aws_s3_bucket" "access_logs" {
  bucket = "tts-dns-terraform-state-logs"

  # Enable versioning for audit trail
  versioning {
    enabled = true
  }

  # Server-side encryption for logs - using KMS instead of AES256
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3_encryption_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  # Retention policy for logs
  lifecycle_rule {
    id      = "log-retention"
    enabled = true

    expiration {
      days = 365
    }
  }

  # Log access to this log bucket to the logs-logs bucket
  logging {
    target_bucket = aws_s3_bucket.logs_for_logs.id
    target_prefix = "log/logs-bucket/"
  }

  # Block public access
  tags = {
    Name    = "terraform-state-logs"
    Project = "dns"
  }
}

# Create bucket for logs of logs
#checkov:skip=CKV_AWS_18:Log-of-logs bucket doesn't need its own access logging to avoid circular dependencies
#checkov:skip=CKV_AWS_144:Cross-region replication not needed for tertiary log data
#checkov:skip=CKV2_AWS_62:Event notifications not essential for logs-of-logs bucket
resource "aws_s3_bucket" "logs_for_logs" {
  bucket = "tts-dns-terraform-state-logs-logs"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3_encryption_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule {
    id      = "logs-retention"
    enabled = true

    expiration {
      days = 365
    }
  }

  tags = {
    Name    = "terraform-state-logs-logs"
    Project = "dns"
  }
}

# Block public access to logs-logs bucket
resource "aws_s3_bucket_public_access_block" "logs_for_logs_public_access_block" {
  bucket = aws_s3_bucket.logs_for_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Block public access to the state bucket
resource "aws_s3_bucket_public_access_block" "backend_public_access_block" {
  bucket = aws_s3_bucket.backend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Block public access to the logs bucket
resource "aws_s3_bucket_public_access_block" "logs_public_access_block" {
  bucket = aws_s3_bucket.access_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# KMS key for S3 bucket encryption
resource "aws_kms_key" "s3_encryption_key" {
  description             = "KMS key for terraform state S3 bucket encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })

  tags = {
    Name    = "terraform-state-kms-key"
    Project = "dns"
  }
}

resource "aws_kms_alias" "s3_key_alias" {
  name          = "alias/terraform-state-key"
  target_key_id = aws_kms_key.s3_encryption_key.key_id
}

# Add data source for account identity
data "aws_caller_identity" "current" {}

# Create SNS topic for S3 bucket event notifications
resource "aws_sns_topic" "s3_events" {
  name = "terraform-state-bucket-events"

  # Enable SNS topic encryption with KMS
  kms_master_key_id = "alias/aws/sns"

  tags = {
    Name    = "terraform-state-sns-topic"
    Project = "dns"
  }
}

# Create logs SNS topic for log bucket event notifications
resource "aws_sns_topic" "logs_events" {
  name = "terraform-logs-bucket-events"

  # Enable SNS topic encryption with KMS
  kms_master_key_id = "alias/aws/sns"

  tags = {
    Name    = "terraform-logs-sns-topic"
    Project = "dns"
  }
}

# Create replica logs SNS topic for replica bucket event notifications
resource "aws_sns_topic" "replica_events" {
  name     = "terraform-replica-bucket-events"
  provider = aws.west

  # Enable SNS topic encryption with KMS
  kms_master_key_id = "alias/aws/sns"

  tags = {
    Name    = "terraform-replica-sns-topic"
    Project = "dns"
  }
}

# Subscribe TTS operations email to the SNS topics
resource "aws_sns_topic_subscription" "s3_events_email" {
  topic_arn = aws_sns_topic.s3_events.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

resource "aws_sns_topic_subscription" "logs_events_email" {
  topic_arn = aws_sns_topic.logs_events.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

resource "aws_sns_topic_subscription" "replica_events_email" {
  provider  = aws.west
  topic_arn = aws_sns_topic.replica_events.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

# Allow S3 to publish to the SNS topics
resource "aws_sns_topic_policy" "s3_events_policy" {
  arn    = aws_sns_topic.s3_events.arn
  policy = data.aws_iam_policy_document.s3_events_policy_document.json
}

resource "aws_sns_topic_policy" "logs_events_policy" {
  arn    = aws_sns_topic.logs_events.arn
  policy = data.aws_iam_policy_document.logs_events_policy_document.json
}

resource "aws_sns_topic_policy" "replica_events_policy" {
  provider = aws.west
  arn      = aws_sns_topic.replica_events.arn
  policy   = data.aws_iam_policy_document.replica_events_policy_document.json
}

data "aws_iam_policy_document" "s3_events_policy_document" {
  statement {
    sid    = "AllowS3ToPublishToSNS"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.s3_events.arn]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.backend.arn]
    }
  }
}

data "aws_iam_policy_document" "logs_events_policy_document" {
  statement {
    sid    = "AllowS3ToPublishToSNS"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.logs_events.arn]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.access_logs.arn]
    }
  }
}

data "aws_iam_policy_document" "replica_events_policy_document" {
  statement {
    sid    = "AllowS3ToPublishToSNS"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.replica_events.arn]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.backend_replica.arn]
    }
  }
}

# Configure S3 event notifications
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.backend.id

  # Notify on all object deletion events
  topic {
    topic_arn     = aws_sns_topic.s3_events.arn
    events        = ["s3:ObjectRemoved:*"]
    filter_suffix = ".tfstate"
  }

  # Notify on state file creation/modification
  topic {
    topic_arn     = aws_sns_topic.s3_events.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".tfstate"
  }
}

resource "aws_s3_bucket_notification" "logs_bucket_notification" {
  bucket = aws_s3_bucket.access_logs.id

  topic {
    topic_arn     = aws_sns_topic.logs_events.arn
    events        = ["s3:ObjectRemoved:*"]
    filter_suffix = ".log"
  }

  topic {
    topic_arn     = aws_sns_topic.logs_events.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }
}

# Create replica bucket in another region
#checkov:skip=CKV_AWS_144:This is already a replica bucket itself and doesn't need further replication
#checkov:skip=CKV2_AWS_62:Event notifications already configured
resource "aws_s3_bucket" "backend_replica" {
  provider = aws.west
  bucket   = "tts-dns-terraform-state-replica"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3_encryption_key_west.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  # Adding lifecycle configuration
  lifecycle_rule {
    id      = "state-files"
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      days = 914
    }
  }

  # Create replica logs bucket in west region
  logging {
    target_bucket = aws_s3_bucket.replica_logs.id
    target_prefix = "log/replica-bucket/"
  }

  tags = {
    Name    = "terraform-state-replica"
    Project = "dns"
  }
}

# Create replica logs bucket in west region
#checkov:skip=CKV_AWS_18:This is a log bucket for the replica and doesn't need its own access logging
#checkov:skip=CKV_AWS_144:This is already in the disaster recovery region, further replication not needed
#checkov:skip=CKV2_AWS_62:Event notifications not essential for log data in disaster recovery region
resource "aws_s3_bucket" "replica_logs" {
  provider = aws.west
  bucket   = "tts-dns-terraform-state-replica-logs"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3_encryption_key_west.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule {
    id      = "logs-retention"
    enabled = true

    expiration {
      days = 365
    }
  }

  tags = {
    Name    = "terraform-state-replica-logs"
    Project = "dns"
  }
}

# Event notifications for replica bucket
resource "aws_s3_bucket_notification" "replica_bucket_notification" {
  provider = aws.west
  bucket   = aws_s3_bucket.backend_replica.id

  topic {
    topic_arn     = aws_sns_topic.replica_events.arn
    events        = ["s3:ObjectRemoved:*"]
    filter_suffix = ".tfstate"
  }

  topic {
    topic_arn     = aws_sns_topic.replica_events.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".tfstate"
  }
}

# Block public access for backend bucket
resource "aws_s3_bucket_public_access_block" "backend" {
  bucket = aws_s3_bucket.backend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Block public access for replica bucket
resource "aws_s3_bucket_public_access_block" "backend_replica" {
  provider = aws.west
  bucket   = aws_s3_bucket.backend_replica.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Block public access for replica logs bucket
resource "aws_s3_bucket_public_access_block" "replica_logs" {
  provider = aws.west
  bucket   = aws_s3_bucket.replica_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create IAM role for S3 replication
resource "aws_iam_role" "replication" {
  name = "terraform-state-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

# Create KMS key in west region
resource "aws_kms_key" "s3_encryption_key_west" {
  provider                = aws.west
  description             = "KMS key for terraform state S3 bucket encryption in west region"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })

  tags = {
    Name    = "terraform-state-kms-key-west"
    Project = "dns"
  }
}

# Create replication policy
resource "aws_iam_policy" "replication" {
  name = "terraform-state-replication-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.backend.arn
        ]
      },
      {
        Action = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl"
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.backend.arn}/*"
        ]
      },
      {
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete"
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.backend_replica.arn}/*"
        ]
      },
      {
        Action = [
          "kms:Decrypt"
        ]
        Effect = "Allow"
        Resource = [
          aws_kms_key.s3_encryption_key.arn
        ]
      },
      {
        Action = [
          "kms:Encrypt"
        ]
        Effect = "Allow"
        Resource = [
          aws_kms_key.s3_encryption_key_west.arn
        ]
      }
    ]
  })
}

# Attach replication policy to role
resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

# Create IAM user for CircleCI deployment permissions
resource "aws_iam_user" "deployer" {
  name = "circleci-deployer"
}
#checkov:skip=CKV_AWS_290: "Ensure IAM policies does not allow write access without constraints"
#checkov:skip=CKV_AWS_289: "Ensure IAM policies does not allow permissions management / resource exposure without constraints"
#checkov:skip=CKV_AWS_355: "Ensure no IAM policies documents allow '*' as a statement's resource for restrictable actions"
#checkov:skip=CKV_AWS_40: "Ensure IAM policies are attached only to groups or roles (Reducing access management complexity may in-turn reduce opportunity for a principal to inadvertently receive or retain excessive privileges.)"
resource "aws_iam_user_policy" "circleci_deployer_policy" {
  name = "route53-deployment"
  user = aws_iam_user.deployer.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "route53:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "${aws_s3_bucket.backend.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "${aws_s3_bucket.backend.arn}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:GenerateDataKey"
            ],
            "Resource": ["${aws_kms_key.s3_encryption_key.arn}"]
        }
    ]
}
EOF
}

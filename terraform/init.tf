provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.31.0"
    }
  }

  required_version = "~> 1.13.1"
  backend "s3" {
    region = "us-east-1"
  }
}

locals {
  // https://docs.aws.amazon.com/general/latest/gr/rande.html#elb_region
  elb_zone_id = "Z35SXDOTRQ7X7K"

  spf_no_mail = "v=spf1 -all"
  spf_hubspot = "v=spf1 include:1962994.spf05.hubspotemail.net ~all"
}

// Keep empty zone parked until it is removed from get.gov
resource "aws_route53_zone" "d_18f_gov_zone" {
  name = "18f.gov."

  tags = {
    Project = "dns",
    # REMOVE THE parked TAG IF RE-POPULATING THIS ZONE! parked="true" will cause validation tests to be skipped
    parked = "true"
  }
}

// All other records have been removed

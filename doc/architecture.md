# DNS architecture

This page attempts to describe the overall architecture of how 18F manages DNS and the associated components that make up the architecture. If you are looking for a refresher on DNS you can check [here](https://docs.google.com/presentation/d/11_bu_a1W2jw57jRT2mteo16TZmSWLOeoVtdf-Flskcg/). The DNS zones that 18F hosts at AWS Route 53 are managed by a set of Terraform configurations stored in a GitHub repository, tested with continuous integration, and deployed and changed in a deployment pipeline, with Slack notifications.

## Diagram

![dns-pipeline](https://user-images.githubusercontent.com/20934414/34623560-7dd34d3c-f217-11e7-95fd-1cc8236d4b5b.png)

## GitHub

The DNS terraform configs and testing and deployment configuration live in this repository. The main and active branch is the `main` branch, which is what is deployed to the live Route53 host. This repo is managed by 18F Infrastructure, and both the cloud.gov and Federalist teams have write access to the repo. The 18F org as a whole has read access.

To make [changes](https://github.com/18F/Infrastructure/wiki/Making-DNS-changes) to the repository, one files a [pull request](https://github.com/18F/dns/pulls) against the `main` branch. The [README](../README.md#making-changes) also provides details on making changes.

## Terraform

The hosted zones are created and managed by Terraform, an infrastructure-as-code management system. The DNS repository makes the assumption that we are using Route 53 and therefore employs the syntax of [aws_route53_zone](https://www.terraform.io/docs/providers/aws/d/route53_zone.html).

Terraform keeps a state file whose integrity is vital to its proper functioning; that state file and its automatic last backup are stored in a S3 bucket called `tts-dns-terraform-state` (available in configuration file [`backend.tfvars`](../terraform/backend.tfvars)).

This document is not meant to replace the Terraform docs themselves; however, there are two things worthy of note:

1. To associate a DNS name with an AWS resource such as a CloudFront distribution, Elastic Load Balancer, S3 bucket, etc. one should use AWS Route 53's own [Alias](http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-choosing-alias-non-alias.html) feature, which is an A record (**not** a CNAME) with an `alias` block rather than with `name` and `records` directives.
2. An Alias record requires a zone ID, a name and a Boolean value for `evaluate_target_health`. A `TTL` is not allowed in an Alias record. (Conversely, `evaluate_target_health` is not allowed in a regular record entry with the `records` keyword.

See below for concrete examples of the foregoing.

### Example

Here's a sample zone definition with a couple of likely records and some output, for **example.com**:

```hcl
# definition of zone -- note that the "example_com_zone" is the zone's name
# reference, free-form but conforming to the general naming conventions seen
# below, for readability

resource "aws_route53_zone" "example_com_zone" {
  name = "example.com"  # may also be a subdomain, "subdomain.example.com"
  tags {
    Project = "dns"
  }
}

# alias of root domain to CloudFront distribution. note that
# a TTL is not allowed in the "alias" stanza.
# "example_com_zone" refers to the zone name reference above

resource "aws_route53_record" "example_com_example_com_cloudfront_a_alias" {
  zone_id = "${aws_route53_zone.example_com_zone.zone_id}"
  name = "example.com"
  type = "A"
  alias {
    name = "<numbersandletters>.cloudfront.net"
    zone_id = "Z2FDTNDATAQYW2"
    # n.b.: Z2FDTNDATAQYW2 is the zone ID for all CloudFront distributions
    evaluate_target_health = false
  }
}

# CNAME of hostname in zone to hostname elsewhere

resource "aws_route53_record" "example_com_host_domain_com_cname" {
  zone_id = "${aws_route53_zone.example_com_zone.zone_id}"
  name = "host.example.com."
  type = "CNAME"
  ttl = 5
  records = ["host.domain.com."]
}

# note that this is a standard A record, not an A-alias, and therefore
# has a "records" stanza.

resource "aws_route53_record" "example_com_host_domain_com_a" {
  zone_id = "${aws_route53_zone.example_com_zone.zone_id}"
  name = "host2.example.com."
  type = "A"
  ttl = 5
  records = ["172.16.11.23"]
}

# Enable DNSSEC

module "example_com_dnssec" {
  source = "./dnssec"
  zone = aws_route53_zone.example_com_zone
}

# Output the DS record that must be added to the parent zone to establish the
# chain of trust.

output "example_com_ds" {
  value = module.example_com_dnssec.ds_record
}

# output name servers for use with registrar of domain, to point
# public DNS at this AWS Route 53 zone

output "example_com_ns" {
  value="${aws_route53_zone.example_com_zone.name_servers}"
}
```

## Validation

Validation is handled by a continuous integration (CI) process implemented as a [CircleCI job](https://circleci.com/gh/18F/dns). The convention for the job name is to base it off of the appropriate description of the actions being performed in that phase. For example, a job that is named validate would correspond to the command _terraform [validate](https://www.terraform.io/docs/commands/validate.html)_ which performs a linting step. Note that the scope of this validate command is very limited at the time of this writing -- this command does not do deep syntax checking, nor does it discover any problems running against existing resources.

As a result, we require a peer review of the changes. GitHub won't merge the change to the `main` branch until a reviewer approves. (As mentioned above, other groups such as federalist reviews its own DNS changes.)

Note that deeper linting of terraform files, along the lines of a dry run, is on [Hashicorp's radar](https://github.com/hashicorp/terraform/issues/11427).

## Deployment

Deployment is handled as a workflow in [CircleCI](https://circleci.com/gh/18F/dns) that happens after a successful validation job. The job is specified in the [circle config](../.circleci/config.yml) which follows an appropriate naming scheme (see above). The deployment consists of a syntax validation check and the Terraform command [_terraform apply_](https://www.terraform.io/docs/commands/apply.html). Terraform accesses AWS from the CircleCI configuration [settings](https://circleci.com/gh/18F/dns/edit).

Output from the job, typically just the nameservers configured for each zone, is visible in CircleCI builds view (see the "output" section in the sample config above). Notification regarding the success or failure of the job is also sent to Slack (see below).

DNS zones that are delegated to us live in the 18F Enterprise AWS account.

## Slack

Infrastructure has its own Slack channel for DNS requests, questions and automated job notifications, **#admins-dns**. When CircleCI runs a DNS job, the channel receives a notification regarding the success or failure of jobs. The Slack integration can be found in CircleCI's configuration [hooks](https://circleci.com/gh/18F/dns/edit#hooks).

## Authentication and secrets

To administer every aspect of the automated DNS system, you will need the following:

- Membership in one of the following GitHub teams: `infrastructure-staff`, `federalist-admins`, `cloud-gov-ops`
- An AWS `ACCESS_KEY_ID` and `SECRET_ACCESS_KEY` with access to the [production Route 53 service](https://18f.signin.aws.amazon.com/console)
- The Slack webhook secret set in CircleCI notifications (check in #admins-slack)

# TTS DNS configuration

[![CircleCI](https://circleci.com/gh/GSA-TTS/dns.svg?branch=main&style-svg)](https://circleci.com/gh/GSA-TTS/dns)

This repository holds the source code for configuring DNS for domains managed by GSA TTS.

- [Technical details about this repository](doc/architecture.md)
- [Modernization and open work implementation plan](doc/implementation_plan.md)

## Local validation

Install [mise](https://mise.jdx.dev/), then install the pinned OpenTofu and
Python versions and run the offline checks:

```sh
mise trust
mise install
mise exec -- tofu -chdir=terraform init -backend=false -input=false -lockfile=readonly
mise exec -- tofu -chdir=terraform validate
mise exec -- python -m pip install -r requirements.txt
mise exec -- python -m pytest -m "not integration" tests
```

The tests marked `integration` query Route 53 and public DNS and therefore
require AWS credentials and network access.

## Making changes

Assuming you're TTS staff, it's recommended that you **make the change in a branch on this repository itself, rather than on a fork**, because the credentials aren't shared with forks. (The `main` branch is [protected](https://help.github.com/articles/about-protected-branches/) to limit write access only to certain staff, and to ensure history doesn't get overwritten, etc.) For major changes, it is recommended to keep the TTL value low just before and during the change period in order to make it easier to verify the changes went through as expected.

1. Is the domain pointing to the right nameservers? In other words, is there a file for the domain under [`terraform/`](terraform) already?
   - **Yes:** Continue to next step.
   - **No:**
     1. Add a file for the domain (or subdomain, if the second-level domain isn't being added), to create the [public hosted zone](http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html).
        - [`analytics.usa.gov`](terraform/analytics.usa.gov.tf) is a good example to copy from.
        - You'll be using Terraform's [`aws_route53_zone`](https://www.terraform.io/docs/providers/aws/d/route53_zone.html).
        - If it's an existing domain, you'll want to make sure all existing records are copied over, so that they don't break when the cutover happens. You can ask the existing DNS managers for a list of records or a [zone file](https://en.wikipedia.org/wiki/Zone_file) for the domain and all subdomains.
     1. After the pull request is merged, to get the name servers for your domain check the output for your build in [CircleCI](https://circleci.com/gh/GSA-TTS/dns). If you need further assistance, check with [#admins-dns](https://gsa-tts.slack.com/messages/C4L58EQ5T).
     1. Change the nameservers for the domain to point to AWS.
        - For second-level domains, this will be done by the "domain manager" in [dotgov.gov](https://www.dotgov.gov/). [More information about .gov domain management.](https://home.dotgov.gov/management/)
1. Add the relevant additional [record sets](http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/rrsets-working-with.html). In Terraform, these are known as [`aws_route53_record`](https://www.terraform.io/docs/providers/aws/r/route53_record.html)s.

It's worth noting that if you are pointing to a CloudFront distro, you should use Route 53's own `alias` and not a CNAME record. In fact, CNAMEing a top-level domain (or the top level of a delegated subdomain) is not allowed in DNS. See the various examples in the repo, such as [this one](https://github.com/GSA-TTS/dns/blob/deploy/terraform/usa.gov.tf#L8-L17).

On merge, changes are deployed to an AWS account hosting the Route53 records automatically by a [CircleCI](https://circleci.com/gh/GSA-TTS/dns) job.

### Redirects

[Redirects are managed here](https://github.com/cloud-gov/pages-redirects) 

If the redirecting domain is assigned to any CloudFront distribution in any AWS account, it will need to be unassociated before the module above can be successfully deployed.

## Stubbing files

We keep a Terraform file for every TTS domain, even if it's just a comment referencing DNS managed elsewhere.

## Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in the [license](LICENSE.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).

> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.

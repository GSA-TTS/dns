import boto3
import dns.exception
import dns.resolver
import pytest


def get_public_zones():
    route53 = boto3.client("route53")
    paginator = route53.get_paginator("list_hosted_zones")
    zones = {}

    for r in paginator.paginate():
        zones.update(
            {
                v["Id"]: v["Name"]
                for v in r["HostedZones"]
                if v["Config"]["PrivateZone"] is False
            }
        )

    return zones

def get_aliases(zone_id, rr_type):
    route53 = boto3.client("route53")
    paginator = route53.get_paginator("list_resource_record_sets")
    aliases = {}

    for r in paginator.paginate(HostedZoneId=zone_id):
        aliases.update(
            {
                v["Name"]: v["AliasTarget"]
                for v in r["ResourceRecordSets"]
                if v["Type"] == rr_type and "AliasTarget" in v
            }
        )

    return aliases

def aaaa_available(dns_name):
    try:
        dns.resolver.resolve(dns_name, "AAAA")
        return True
    except (dns.resolver.NoAnswer, dns.exception.Timeout):
        pass

    return False

@pytest.mark.integration
def test_missing_aaaa_for_v6_enabled_target():
    """
    Look for any alias A records without a matching AAAA record
    where the alias target does have an AAAA record.
    """
    for zone_id, zone_name in get_public_zones().items():
        all_a = get_aliases(zone_id, "A")
        all_aaaa = get_aliases(zone_id, "AAAA")
        missing = all_a.keys() - all_aaaa.keys()

        available = {name for name in missing if aaaa_available(all_a[name]["DNSName"])}

        assert available == set(), f"{zone_name} has aliases missing AAAA records"

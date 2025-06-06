import boto3
import checkdmarc
import pytest


def is_second_level_domain(zone):
    levels = zone["Name"].rstrip(".").split(".")
    return len(levels) == 2


def test_is_second_level_domain():
    assert is_second_level_domain({"Name": "foo.bar"})
    assert is_second_level_domain({"Name": "foo.bar."})
    assert not is_second_level_domain({"Name": "foo.bar.baz."})


def is_not_parked(zone_tags):
    """Return true unless a zone has a tag with key 'parked' and value 'true'"""
    for t in zone_tags:
        if t["Key"] == "parked" and t["Value"] == "true":
            return False

    return True


def test_is_not_parked():
    assert is_not_parked([{"Key": "parked", "Value": "false"}])
    assert is_not_parked([{"Key": "stuff", "Value": "true"}])
    assert not is_not_parked([{"Key": "parked", "Value": "true"}])
    assert not is_not_parked(
        [{"Key": "something", "Value": "else"}, {"Key": "parked", "Value": "true"}]
    )


def get_zone_tags(route53_client, zone):
    return [
        t
        for t in route53_client.list_tags_for_resource(
            ResourceType="hostedzone",
            ResourceId=zone["Id"].removeprefix("/hostedzone/"),
        )
        .get("ResourceTagSet", {})
        .get("Tags", [])
    ]


def second_level_domains():
    """Returns the set of second-level domains we control."""
    route53 = boto3.client("route53")
    response = route53.list_hosted_zones()
    return set(
        zone["Name"].rstrip(".")
        for zone in response["HostedZones"]
        if is_second_level_domain(zone) and is_not_parked(get_zone_tags(route53, zone))
    )


# all second-level domains must have SPF and DMARC
# https://cyber.dhs.gov/bod/18-01/#compliance-guide
@pytest.mark.parametrize("domain", second_level_domains())
def test_has_email_security_records(domain):
    result = checkdmarc.check_domains([domain])

    assert result["spf"]["valid"], f"{domain} has missing/invalid SPF record"
    assert result["dmarc"]["valid"], f"{domain} has missing/invalid DMARC record"

    # https://cyber.dhs.gov/bod/18-01/#where-should-dmarc-reports-be-sent
    reporting_addrs = [
        val["address"] for val in result["dmarc"]["tags"]["rua"]["value"]
    ]
    assert any(addr == "reports@dmarc.cyber.dhs.gov" for addr in reporting_addrs)

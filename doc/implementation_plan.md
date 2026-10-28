# Modernization and Open Work Implementation Plan

Last reviewed: 2026-10-01

## Objectives

1. Replace Terraform 1.1.5 with the latest stable OpenTofu release.
2. Upgrade and reproducibly lock the Python validation dependencies.
3. Upgrade the AWS provider without combining provider schema changes with the
   OpenTofu migration.
4. Make validation a pre-deployment gate.
5. Triage and complete, close, or explicitly defer every open issue.

The work should be delivered as several focused pull requests. DNS and state
changes have a larger blast radius than ordinary application changes, so each
pull request must produce a reviewed plan and have a documented rollback.

## Current State

| Area | Current configuration | Target |
| --- | --- | --- |
| IaC CLI | Terraform 1.1.5 in CircleCI | OpenTofu 1.13.1 |
| Local tool versions | `.tool-versions` pins Terraform 0.11.14 | `mise.toml` pins OpenTofu and Python |
| IaC constraint | `required_version = "~> 1.1"` | `required_version = "~> 1.13.1"` |
| AWS provider | `hashicorp/aws` 3.31.0 | 6.67.0, reached one major at a time |
| Python runtime | Python 3.9 Alpine | A supported Python 3.13 image |
| boto3 | `~=1.26` | 1.43.106 |
| checkdmarc | `~=5.9` | 6.0.3 |
| pytest | `~=7.3` | 9.1.1 |
| dnspython | `~=2.6.0rc1` | 2.8.0 |
| urllib3 | Directly constrained to `~=1.26` | Remove the unused direct dependency |

Version targets are the latest stable releases found on the review date. They
must be checked again when each upgrade pull request is opened. `mise.toml`
will be the source of truth for exact OpenTofu and Python versions used locally
and in CI. Container images must also be pinned to an exact tag, preferably by
image digest. The provider and all Python transitive dependencies should remain
locked in committed lock files.

Important findings:

- `.circleci/config.yml` runs Python validation only after production apply and
  only on `main`. Pull requests therefore do not exercise these tests.
- `.tool-versions` pins Terraform 0.11.14 even though CircleCI uses Terraform
  1.1.5. This stale second source of truth should be replaced by `mise.toml`.
- The Python tests access AWS and public DNS during test collection. They are
  integration checks, not isolated unit tests, and need credentials and stable
  network access.
- `terraform/init.tf` constrains the provider to exactly 3.31.0. The existing
  `.terraform.lock.hcl` reflects that constraint.
- `terraform/bootstrap` is a separate root configuration with no explicit CLI
  or provider constraint and no committed lock file.
- The bootstrap configuration uses inline S3 versioning, lifecycle, logging,
  and replication blocks that require migration for newer AWS provider majors.
- There are 11 open issues and no open pull requests.

## Delivery Plan

### Phase 0: Establish Safety and Baselines

Deliver this before changing dependency versions.

1. Record the exact current production plan using Terraform 1.1.5 and AWS
   provider 3.31.0. Preserve the plan output as a CI artifact for comparison.
2. Back up the versioned S3 state and verify that a previous object version can
   be identified and restored. Do not copy state into the repository.
3. Document the production deployment owner, maintenance window, rollback
   operator, and AWS account expected by CI.
4. Split CI into these gates:
   - Static checks: formatting, `validate`, Checkov, and the maintained IaC
     security scanner.
   - Offline Python unit tests, runnable for every pull request without AWS.
   - Credentialed DNS integration tests, runnable before production apply on
     trusted branches.
   - Production apply, restricted to `main`, requiring every prior gate.
5. Stop persisting `.terraform` working-directory contents between jobs. Save
   an explicit plan artifact with `tofu plan -out`, then apply that reviewed
   artifact in the deploy job. Ensure the artifact is protected from forked
   pull requests and cannot outlive the commit it was generated for.
6. Replace shell-based branch-name detection of forks with CircleCI-native
   workflow filters or explicit credential detection.
7. Add a CI bootstrap step that installs mise using a pinned release, runs
   `mise install`, and verifies `tofu version` and `python --version`. Cache
   downloaded tools by the `mise.toml` checksum without caching credentials or
   `.terraform` directories.

Acceptance criteria:

- Pull requests run formatting, initialization without a backend, validation,
  security scanning, and offline tests.
- No validation job depends on a production apply.
- A trusted `main` build applies only the plan generated for the same commit.
- The baseline production plan is understood and contains no unrelated change.

### Phase 1: Migrate the CLI to OpenTofu

Keep AWS provider 3.31.0 fixed during this phase so any observed difference is
attributable to the CLI migration.

1. Recheck the latest stable OpenTofu release. The target as of this review is
   1.13.1.
2. Add a root `mise.toml` with exact OpenTofu and Python versions. Start with:

   ```toml
   [tools]
   opentofu = "1.13.1"
   python = "3.13"
   ```

   Resolve Python to an exact supported 3.13 patch during implementation if
   the mise backend does not lock the patch automatically. Remove the obsolete
   `.tool-versions` file so there is only one local tool-version definition.
3. Change the root `required_version` to `~> 1.13.1`. Add equivalent
   `terraform.required_version` and `required_providers` declarations to the
   bootstrap root.
4. Run CircleCI jobs in a minimal pinned base image, install the versions from
   `mise.toml`, and replace CI invocations of `terraform` with `tofu`. Do not
   duplicate the OpenTofu or Python versions in separate job definitions.
5. Run `tofu fmt -check -recursive`, `tofu init -backend=false`, and
   `tofu validate` against both `terraform/` and `terraform/bootstrap/`.
6. With production credentials, initialize the S3 backend without migration
   flags and run a refresh-only plan followed by a normal plan. Review both for
   state decoding differences and unintended resource changes.
7. Retain and regenerate `.terraform.lock.hcl` with OpenTofu for all supported
   CI/developer platforms. Add a lock file for the bootstrap root if it remains
   an independently operated configuration.
8. Update `README.md` and `doc/architecture.md` to use OpenTofu terminology and
   `mise install`/`mise exec` commands. Document that operators must not
   alternate Terraform and OpenTofu after migration without a compatibility
   review.
9. Apply only if the reviewed plan has no unexplained changes. Verify state
   access and run a second plan expecting no changes.

Rollback:

- Revert the CI/configuration commit and restore the pre-migration state object
  version only if OpenTofu wrote incompatible or incorrect state. A normal
  no-op OpenTofu run should not require state restoration.

Acceptance criteria:

- Both roots initialize and validate with OpenTofu 1.13.1.
- `mise install` provides the documented OpenTofu and Python versions, and CI
  confirms those versions before running checks.
- `.tool-versions` is removed and tool versions are not duplicated elsewhere.
- The existing provider remains at 3.31.0.
- Production has a reviewed no-change plan before and after migration.
- Issue #732 is updated to track the provider follow-up and can be closed when
  Phase 3 is complete.

### Phase 2: Upgrade Python and Make Installs Reproducible

1. Install the Python version pinned in `mise.toml` in CI instead of relying on
   the mutable `python:3.9-alpine` job image. Use a pinned Debian-based base
   image unless Alpine is required, because `cryptography` and its native
   dependencies are less likely to require local compilation.
2. Separate direct dependency intent from the resolved environment:
   - Keep direct test dependencies in `requirements.in` or a clearly documented
     equivalent.
   - Generate a fully resolved `requirements.txt` with hashes using `pip-tools`.
   - Pin the `pip-tools` version used to regenerate the file.
3. Upgrade one direct package at a time in this order: boto3, dnspython,
   pytest, then checkdmarc. Regenerate the lock and run tests after each step.
4. Remove direct `urllib3`; repository code does not import it. Let boto3 and
   checkdmarc select a compatible transitive release unless a documented
   security override is required.
5. Replace the release-candidate dnspython constraint with stable 2.8.0.
6. Adapt tests to checkdmarc 6 output and stricter RFC validation. Treat newly
   reported SPF, DMARC, or DNSSEC failures as domain findings to investigate,
   not as reasons to weaken assertions globally.
7. Prevent AWS calls during test collection. Move client creation and hosted
   zone discovery into fixtures, mark live checks as integration tests, and
   retain small unit tests with mocked API responses.
8. Run `pip check`, offline tests, and the credentialed integration suite. Add
   a scheduled integration run so external DNS failures are visible without
   blocking unrelated pull requests indefinitely.

Acceptance criteria:

- A clean environment installs from the hash-checked lock without resolver
  drift.
- Tests run on Python 3.13 and pytest 9.1.1.
- Offline tests do not require AWS credentials or DNS access.
- Live DNS tests pass or produce separately tracked, owner-assigned findings.

### Phase 3: Upgrade the AWS Provider Through Each Major

Do not jump directly from 3.31.0 to 6.67.0 in one change. Use one pull request
per provider major and require a no-change or fully explained production plan
at every step.

1. Update to the latest compatible 3.x patch and regenerate the lock file.
2. Upgrade to 4.x and follow the provider's v4 guide. Pay particular attention
   to authentication precedence and S3 resources.
3. Before or during the v4 step, refactor each bootstrap S3 bucket's inline
   configuration into the dedicated resources required by current provider
   schemas, including versioning, lifecycle, logging, encryption, and
   replication. Use `moved`/import operations where needed to avoid replacing
   any state, log, or replica bucket.
4. Upgrade to 5.x and remove or replace deprecated arguments identified by the
   v5 guide and provider diagnostics.
5. Upgrade to 6.67.0 and review the v6 regional-resource behavior and any new
   default-value diffs.
6. At each step run format, init with upgrade, validate, security scans,
   refresh-only plan, normal plan, and integration tests. Commit the resulting
   lock-file change.
7. Run the bootstrap root separately from the primary DNS root. It has a
   different lifecycle and must never be casually applied as part of routine
   DNS deployment.

Acceptance criteria for every major:

- No bucket, hosted zone, DNSSEC key, KMS key, IAM principal, or state backend
  replacement is accepted merely as an upgrade side effect.
- Every plan difference is classified as expected migration, harmless state
  normalization, or a defect to fix before merge.
- A post-apply plan is empty.

### Phase 4: Harden and Maintain the Toolchain

1. Replace or update the old `mycodeself/tfsec@1.1.0` integration. Confirm the
   selected scanner officially parses current OpenTofu syntax.
2. Pin the Checkov image/version instead of installing an unbounded latest
   release on every build. Review each skip in `.circleci/config.yml` against
   `doc/checkov.md`; keep only resource-scoped, justified exceptions.
3. Configure Renovate for `mise.toml`, the provider, CircleCI image, and Python
   lock updates. Group patch updates but keep provider major upgrades separate.
4. Add a scheduled drift-detection plan with notification and no automatic
   apply.
5. Add a short operator runbook covering local validation, plan review, state
   recovery, failed Route 53 changes, and deployment rollback.

## Open Issue Review

The following review reflects the 11 issues open on 2026-10-01. Every issue
should first receive an owner and a current-status comment. Stale operational
requests should not be implemented without reconfirmation from the domain
owner.

| Issue | Assessment | Proposed disposition |
| --- | --- | --- |
| #813 Avoid CNAME Destroy/Create Race Condition | Valid reliability concern, but `create_before_destroy = false` is already the default and does not order two different resource addresses. | Reproduce from the failed plan. Prefer updating the target on the existing resource address. For a rename, use a `moved` block or `tofu state mv` so OpenTofu performs one Route 53 update rather than destroy/create. Add a documented rerun/recovery procedure and close after a tested replacement. |
| #732 Terraform Upgrade Path | Active and superseded in scope by the OpenTofu decision. Its provider analysis is outdated. | Use Phases 1 and 3 as the implementation. Retitle/update the issue to OpenTofu and AWS provider migration, link all upgrade PRs, and close after provider 6.x is deployed with an empty follow-up plan. |
| #731 Security Policy violation | Valid; no `SECURITY.md` exists. | Add `SECURITY.md` using the GSA-approved private vulnerability reporting route, enable the GitHub security policy, and let Allstar verify closure. Do not direct vulnerabilities to public issues. |
| #730 Branch Protection violation | Current branch protection has signatures and one approval, but `enforce_admins` is false; the latest Allstar result specifically flags enforcement for admins. | Enable required status checks for administrators. Before doing so, replace the sole legacy `ci/circleci: plan` requirement with all new Phase 0 checks and confirm administrators retain an emergency procedure that is audited rather than bypassing protection. |
| #716 DAP domain request | Operational support request from 2024. The CNAME still points to CloudFront, whose edge IP ranges are dynamic. | Confirm whether the requester still needs help. Respond with the supported AWS IP-range/CloudFront guidance rather than a static DNS-derived allowlist, then close or transfer to the DAP support channel. No DNS code change is indicated. |
| #715 Remove public facing Google Form | Still actionable: `proposal.pif.gov` and its ACME validation CNAME remain in `terraform/pif.gov.tf`. | Reconfirm decommissioning with the PIF owner, lower TTL if a transition is needed, remove both records, review the plan for only two deletions, verify NXDOMAIN after propagation, and close. |
| #580 Redirect private-eye.18f.gov | No matching resource remains in the repository; request dates to 2022. DNS alone cannot provide an HTTP redirect. | Verify current DNS and redirect behavior with the domain owner. Close as completed/stale if already decommissioned; otherwise create redirect work in the service that owns HTTP redirects and add only the required DNS target here. |
| #526 DRY the IPv6 configuration? | A design question from 2021, not a demonstrated defect. Broad deduplication across DNS records can hide intentional A/AAAA differences. | Reassess after the toolchain upgrade. Prototype only if it materially improves validation or safety; otherwise document the explicit-record convention and close as not planned. |
| #525 Redirect Agile Labor Categories | No matching resource remains in the repository; the requested six-month redirect window expired years ago. | Verify live DNS and the domain inventory, then close as completed/stale. Open a new, current request only if an active redirect is still required. |
| #524 Confirm all domains are preloaded | HSTS preload is an HTTPS/domain-governance audit, not purely DNS work, and the issue has no acceptance criteria. | Define the authoritative domain inventory, query the supported preload status endpoint, record exceptions and owners, and move ongoing monitoring to the appropriate web-security repository/service. Close this issue after the one-time report is linked. |
| #514 Document the email security module | Partial documentation exists in `doc/email_architectures.md`, but it does not document the module interface or match all implementation details. | Add module-specific documentation for inputs, generated SPF/DMARC records, reporting addresses, examples, limitations, and migration guidance; link it from the README and close. |

## Recommended Order and Dependencies

1. Phase 0 CI safety and issue #730 status-check preparation.
2. Phase 1 OpenTofu migration.
3. Phase 2 Python upgrades. This may proceed in parallel with provider work
   after Phase 0, but should remain a separate pull request series.
4. Phase 3 provider upgrades, one major per pull request.
5. Phase 4 ongoing automation and documentation.
6. Low-risk repository governance work: #731 and #514.
7. Confirm and execute operational requests: #715, #716, #580, #525, and #524.
8. Address #813 before the next CNAME migration; decide #526 after upgrades.

No dependency upgrade pull request should contain unrelated production DNS
record changes. This keeps rollback and plan review unambiguous.

## Overall Definition of Done

- CI and operator documentation consistently install pinned OpenTofu and Python
  releases from `mise.toml`.
- The AWS provider is on the reviewed current major with committed lock files
  and no unexplained production drift.
- Python uses a supported runtime and a reproducible, hash-checked dependency
  lock; no release-candidate or unused direct dependency remains.
- Validation and security checks complete before production deployment.
- Production apply uses the exact reviewed plan for the same commit.
- All 11 currently open issues have an owner and are completed, closed with a
  documented reason, or moved to a named backlog with acceptance criteria.
- A post-migration production plan reports no changes.

## Initial Compatibility Results

The following local checks were completed on 2026-10-01 without initializing
or reading the production backend:

- `mise install` installed OpenTofu 1.13.1 and Python 3.13.7 successfully.
- The primary DNS root initialized with its existing AWS provider 3.31.0 and
  passed `tofu validate`. OpenTofu rewrote the provider lock address from
  `registry.terraform.io` to `registry.opentofu.org` while preserving 3.31.0.
- The bootstrap root initially failed validation because `notification_email`
  was used but not declared. Adding the missing typed variable declaration
  resolved the error.
- As a compatibility probe, the unconstrained bootstrap root initialized and
  validated with AWS provider 6.67.0. It emitted ten warnings for deprecated
  inline S3 configuration but no provider schema errors. The committed upgrade
  must still retain provider 3.31.0 until the staged provider work in Phase 3.
- Existing `requirements.txt` dependencies install successfully on Python
  3.13.7 and pass `pip check`.
- Proposed latest direct dependencies also install together on Python 3.13.7,
  pass `pip check`, and compile the test files successfully.
- Pytest cannot collect either test module without AWS credentials because
  both modules call Route 53 while decorators are evaluated at import time.
- `tofu fmt -check -recursive` reports existing formatting differences in
  `terraform/bootstrap/init.tf`, `terraform/dnssec/locals.tf`, and
  `terraform/email_security/vars.tf`.

A production plan was intentionally not run because no AWS credentials were
available and backend access was outside this local compatibility check.

## Reference Material

- [OpenTofu migration guide](https://opentofu.org/docs/intro/migration/migration-guide/)
- [OpenTofu dependency lock files](https://opentofu.org/docs/language/files/dependency-lock/)
- [OpenTofu releases](https://github.com/opentofu/opentofu/releases)
- [AWS provider releases and upgrade guides](https://github.com/hashicorp/terraform-provider-aws/releases)
- [pip-tools](https://pip-tools.readthedocs.io/)
- [checkdmarc changelog](https://github.com/domainaware/checkdmarc/blob/master/CHANGELOG.md)
- [pytest compatibility guidance](https://docs.pytest.org/en/stable/backwards-compatibility.html)
- [urllib3 v2 migration guide](https://urllib3.readthedocs.io/en/stable/v2-migration-guide.html)

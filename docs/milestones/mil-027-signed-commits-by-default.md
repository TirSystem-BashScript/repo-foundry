# MIL-027 Require signed commits by default

## Metadata
| Key | Value |
| --- | --- |
| ID | MIL-027 |
| CrossReference | [BC-001], [US-001], [MIL-024], [MIL-025], [MIL-026] |
| Language | en |
| Domain | it |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-11-05 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version | [14b519e] |

---

## Purpose

[MIL-024] added the optional key `PROTECTED_REQUIRE_SIGNED_COMMITS`, off by default, until signing was set up. The Maintainer has now set up signing (the wiki page `SshSigning`) and wants the rule of every repository that RepoFoundry makes or protects to refuse a pull request that holds a commit without a verified signature. The default of the key becomes `true`.

The change has a risk that the Maintainer accepts: a merge made in the Gitea web interface creates a merge commit that Gitea signs only if the administrator has set up a signing key for the instance. Without it, such a merge may be refused on a repository that requires signed commits. A project that cannot sign sets `PROTECTED_REQUIRE_SIGNED_COMMITS=false` in `config.env`.

## Deliverable

The default of `PROTECTED_REQUIRE_SIGNED_COMMITS` is `true`. The rule that `create-project.sh` makes for a new Gitea repository, and the rule that `--protect OWNER/NAME` creates or compares, carries `require_signed_commits` set to `true` when the key is absent; `false` in `config.env` switches it off. The plan names the requirement, `--protect` shows a rule that does not require signatures as different and changes it only after a yes, and the documents say what the Maintainer must have in place: signing set up on every machine that commits, and a signing key for the Gitea instance for merges made in the web interface. No other behaviour changes.

No token value is printed, put on a command line or written anywhere new. No new host is called.

## Go / No-Go Criteria

| # | Criterion (objectively checkable) | Go | No-Go |
| --- | --- | --- | --- |
| 1 | Without the key, the rule request carries `"require_signed_commits":true` | Tests pass | Any other value |
| 2 | With `PROTECTED_REQUIRE_SIGNED_COMMITS=false` the request carries `"require_signed_commits":false` | Tests pass | The value is not honoured |
| 3 | The plan of a new repository says that signed commits are required, and does not when the key is `false` | Tests pass | The plan is silent or wrong |
| 4 | `--protect` shows a rule that does not require signed commits as different, and changes it only after a yes | Tests pass | The difference is ignored |
| 5 | The README, `config.env.example`, `GettingStarted` and `SshSigning` (three languages) and UC-001 state the new default, how to turn it off, and the two preconditions | Reviewed by S02 | A document still says the default is `false`, or the preconditions are missing |
| 6 | `CHANGELOG.md` states the change under `## [Unreleased]` as a change of default | Reviewed by S02 | No entry |
| 7 | The full run of `tests/run-tests.sh` reports 0 failed checks and 0 failed static checks | Tests pass | A failed check |
| 8 | The Maintainer has confirmed that a merge made in the Gitea web interface of a repository with the rule succeeds (the Gitea instance signs merge commits), or accepts that it may be refused | Confirmed by S01 in chat | Neither is said |
| 9 | The Quality run on the tip of `main` after the merge is green | Verified on Gitea | A red run |

## Dependencies

| Depends on | Reason |
| --- | --- |
| [MIL-024] | It added the key and the request field; this milestone changes the default |
| [MIL-025] | It is the other change of the same rule, merged first so the comparison in `--protect` covers both |
| [MIL-026] | Version 0.4.0 is released with the default off; this change goes into the next version |

## Traceability

| Business Case objective / KPI / user story | Reference |
| --- | --- |
| Repeatable creation with the settings a project needs | [BC-001] |
| User story US-001, a project is created with its repositories | [US-001] |

## Ownership

| Role | Stakeholder ID (SA) |
| --- | --- |
| Owner | S01 |
| Approving reviewer | S02 |

## Target Date

2027-03-05 — proposed; the Business Case sets no deadline.

## Tasks

| # | Task | Summary | Needs its own Use Case/User Story? | Reference |
| --- | --- | --- | --- | --- |
| 1 | Change the default | In `src/lib/constants.sh` set `DEFAULT_PROTECTED_REQUIRE_SIGNED` to `true`; update the tests of `tests/test-protection.sh` that check the whole body, the plan line and the fixture of a rule that is as wanted, and add the tests of criteria 1 to 4. | No | US-001 |
| 2 | Update the use case documents | UC-001 (`uc.md`) names the new default and the preconditions. | No | |
| 3 | Document the default | README, `config.env.example`, `GettingStarted` and `SshSigning` (English, Danish, Bahasa Melayu, translation headers updated) and `CHANGELOG.md`. | No | |

---

[BC-001]: ../business-case.md
[US-001]: ../user-stories.md
[MIL-024]: ./mil-024-require-signed-commits.md
[MIL-025]: ./mil-025-block-merge-rules.md
[MIL-026]: ./mil-026-release-0-4-0.md
[14b519e]: https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/commit/14b519ecad7a44c6e6cc8a2cb344ae532cfcf887

# MIL-024 Optional signed-commit requirement in the branch protection rule

## Metadata
| Key | Value |
| --- | --- |
| ID | MIL-024 |
| CrossReference | [BC-001], [US-001], [MIL-021], [MIL-022] |
| Language | en |
| Domain | it |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-11-04 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version | [fd8d8d6] |

---

## Purpose

The branch protection rule of [MIL-021] and [MIL-022] cannot require signed commits, and Gitea has the setting (`require_signed_commits`). A project that signs its commits wants the rule to enforce it; a project whose commits are not all signed must not be blocked by it. The setting is therefore a choice of the Maintainer, off by default, until signing is set up on every machine (the wiki page `SshSigning` explains how).

## Deliverable

An optional `config.env` key `PROTECTED_REQUIRE_SIGNED_COMMITS` (`true` or `false`, default `false`). The rule that `create-project.sh` makes for a new Gitea repository, and the rule that `--protect OWNER/NAME` creates or compares, carries `require_signed_commits` with that value. The plan, the comparison of `--protect` and the messages show it. Nothing else in the rule changes, and an absent key behaves exactly as before.

No token value is printed, put on a command line or written anywhere new. No new host is called.

## Go / No-Go Criteria

| # | Criterion (objectively checkable) | Go | No-Go |
| --- | --- | --- | --- |
| 1 | Without the key, the rule request carries `"require_signed_commits":false` and the behaviour is as before | Tests pass | Any other value, or a changed request |
| 2 | With `PROTECTED_REQUIRE_SIGNED_COMMITS=true` the rule request carries `"require_signed_commits":true` | Tests pass | The value is not sent |
| 3 | Any other value than `true` or `false` is refused with a message that names the key and the file | Tests pass | It is accepted, or the message is missing |
| 4 | The plan of a new repository shows when the requirement is on | Tests pass | The plan is silent |
| 5 | `--protect` compares the setting: a rule that differs is shown and changed only after a yes, a rule that matches is left alone | Tests pass | The setting is ignored |
| 6 | The README, `config.env.example`, `GettingStarted` (three languages) and UC-001 name the key and its default | Reviewed by S02 | Documents are silent |
| 7 | `CHANGELOG.md` states the change under `## [Unreleased]` | Reviewed by S02 | No entry |
| 8 | The full run of `tests/run-tests.sh` reports 0 failed checks and 0 failed static checks | Tests pass | A failed check |
| 9 | The Quality run on the tip of `main` after the merge is green | Verified on Gitea | A red run |

## Dependencies

| Depends on | Reason |
| --- | --- |
| [MIL-021] | It made the rule, its keys and the request builder that this milestone extends |
| [MIL-022] | `--protect` compares and changes the rule field by field |

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

2027-02-23 — proposed; the Business Case sets no deadline.

## Tasks

| # | Task | Summary | Needs its own Use Case/User Story? | Reference |
| --- | --- | --- | --- | --- |
| 1 | Read and validate the key | In `src/lib/constants.sh` add `PROTECTED_REQUIRE_SIGNED_COMMITS` to the config keys with the default `false`; in `src/lib/config.sh` and `src/lib/validate.sh` accept only `true` or `false`. Tests of criterion 3. | No | US-001 |
| 2 | Send and compare the setting | In `src/lib/protection.sh` add `require_signed_commits` to the request body, the plan summary and the state compared by `--protect`. Tests of criteria 1, 2, 4 and 5. | No | US-001 |
| 3 | Update the use case documents | UC-001 (`uc.md`, `sd.md`, `dcd.md`) and `docs/dcd.md` name the setting. | No | |
| 4 | Document the key | README, `config.env.example`, `GettingStarted` (English, Danish, Bahasa Melayu, translation headers updated) and `CHANGELOG.md`. | No | |

---

[BC-001]: ../business-case.md
[US-001]: ../user-stories.md
[MIL-021]: ./mil-021-protect-default-branch.md
[MIL-022]: ./mil-022-protect-existing-repository.md
[fd8d8d6]: https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/commit/fd8d8d624a2817a3d9ae95da4ddd70270a1f9261

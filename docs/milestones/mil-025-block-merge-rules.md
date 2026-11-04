# MIL-025 Block-merge settings in the branch protection rule

## Metadata
| Key | Value |
| --- | --- |
| ID | MIL-025 |
| CrossReference | [BC-001], [US-001], [MIL-021], [MIL-022], [MIL-024] |
| Language | en |
| Domain | it |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-11-04 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version | pending |

---

## Purpose

The branch protection rule that [MIL-021] and [MIL-022] make stops a direct push and holds the status checks, but a pull request can still be merged while a reviewer has asked for changes, while a review is pending, while the branch is behind `main`, and by an administrator who ignores the rule. The rule of the organisation's framework repository sets these four blocks, and a repository made or protected by RepoFoundry should get the same, so the rule means what it says for everyone.

## Deliverable

The rule that `create-project.sh` makes for a new Gitea repository, and the rule that `--protect OWNER/NAME` creates or changes, always carries four settings, all on:

- block merge on rejected reviews (`block_on_rejected_reviews`);
- block merge on official review requests (`block_on_official_review_requests`);
- block merge if the pull request is outdated (`block_on_outdated_branch`);
- administrators must follow the branch protection rules (`block_admin_merge_override`).

They are fixed, like "no direct push": no `config.env` key turns them off. `--protect` compares them with the rule on the repository and, where one is off, shows the difference and changes it only after a yes, as for the other settings. The plan, the dry run and the messages name them.

The number of required approvals is not changed: it stays at the Gitea default (0), so a single Maintainer can merge a pull request. No token value is printed, put on a command line or written anywhere new. No new host is called.

## Go / No-Go Criteria

| # | Criterion (objectively checkable) | Go | No-Go |
| --- | --- | --- | --- |
| 1 | The create and edit request carries the four settings as `true` | Tests pass | A setting is missing or `false` |
| 2 | No `config.env` key can turn one of them off; the keys are refused as unknown | Tests pass | A key is accepted |
| 3 | The plan of a new repository names the four blocks | Tests pass | The plan is silent |
| 4 | `--protect` shows a rule where one of the four is off as different, and changes it only after a yes | Tests pass | The difference is ignored, or changed without a yes |
| 5 | `--protect` leaves a rule that already has all four on and is otherwise as wanted untouched | Tests pass | A change request is sent |
| 6 | The required approvals are not sent | Tests pass | The request sets approvals |
| 7 | The README, `GettingStarted` (three languages) and UC-001 name the four blocks | Reviewed by S02 | Documents are silent |
| 8 | `CHANGELOG.md` states the change under `## [Unreleased]` | Reviewed by S02 | No entry |
| 9 | The full run of `tests/run-tests.sh` reports 0 failed checks and 0 failed static checks | Tests pass | A failed check |
| 10 | The Quality run on the tip of `main` after the merge is green | Verified on Gitea | A red run |

## Dependencies

| Depends on | Reason |
| --- | --- |
| [MIL-024] | It extends the same request body, plan line and comparison in `src/lib/protection.sh`, so this milestone is merged after it |

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

2027-02-25 — proposed; the Business Case sets no deadline.

## Tasks

| # | Task | Summary | Needs its own Use Case/User Story? | Reference |
| --- | --- | --- | --- | --- |
| 1 | Send and compare the four blocks | In `src/lib/protection.sh` add the four settings to the request body, the plan summary and the state compared by `--protect`; update the existing tests that check the whole body and add the tests of criteria 1 to 6. | No | US-001 |
| 2 | Update the use case documents | UC-001 (`uc.md`, `sd.md`, `dcd.md`) and `docs/dcd.md` name the four blocks. | No | |
| 3 | Document the blocks | README, `GettingStarted` (English, Danish, Bahasa Melayu, translation headers updated) and `CHANGELOG.md`. | No | |

---

[BC-001]: ../business-case.md
[US-001]: ../user-stories.md
[MIL-021]: ./mil-021-protect-default-branch.md
[MIL-022]: ./mil-022-protect-existing-repository.md
[MIL-024]: ./mil-024-require-signed-commits.md

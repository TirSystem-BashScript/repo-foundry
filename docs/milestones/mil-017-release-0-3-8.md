# MIL-017 Release 0.3.8

## Metadata
| Key | Value |
| --- | --- |
| ID | MIL-017 |
| CrossReference | [BC-001], [US-001], [MIL-016] |
| Language | en |
| Domain | it |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-10-28 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version | [2d3932f] |

---

## Purpose

Decide whether the work merged since `v0.3.7` is released as version 0.3.8. The last release is `v0.3.7` (2026-10-19). Since then `main` has the framework pin move to `v0.15.0` and the pin move to `v0.17.1`, with `TP` and `AD` added to the register table of the Artifact Registry. `CHANGELOG.md` holds these under `## [Unreleased]`, and `VERSION` still says 0.3.7. A release is deliberate: the Release workflow runs only on request, defaults to a dry run, and refuses a version that has no entry in `CHANGELOG.md`.

## Deliverable

Version 0.3.8 of `create-project.sh`, released on Gitea: `VERSION` and the `--version` check say 0.3.8; `CHANGELOG.md` has a dated `## [0.3.8]` entry and an empty `## [Unreleased]`; the tag `v0.3.8` and its release page exist, made by the Release workflow from the tip of `main`, and the moving tag `v0` points to it.

The change is a patch release: the only change to the script is its version number. The credentials the script asks for, its host requests and its steps do not change.

## Go / No-Go Criteria

| # | Criterion (objectively checkable) | Go | No-Go |
| --- | --- | --- | --- |
| 1 | `create-project.sh --version` prints `RepoFoundry 0.3.8` | Tests pass | Another version |
| 2 | `CHANGELOG.md` has a `## [0.3.8]` entry with its date that matches the changes since `v0.3.7`, and `## [Unreleased]` holds no entry | Reviewed by S02 | An entry missing, or text left under Unreleased |
| 3 | The Quality run on the tip of `main` is green, and no test fails that passed at `v0.3.7` | Tests pass | A new failure |
| 4 | The Release workflow, run with version `0.3.8` and `dry_run` true, checks the version, the tip of `main` and the changelog entry and writes nothing | Dry run passes | The dry run reports an error |
| 5 | After the run with `dry_run` false, the tag `v0.3.8` and its release page exist on Gitea, and the page text is the changelog entry | Verified on Gitea | No tag, no page, or another text |
| 6 | The moving tag `v0` points to the same commit as `v0.3.8` | Verified on Gitea | `v0` elsewhere |

## Dependencies

| Depends on | Reason |
| --- | --- |
| [MIL-016] | The 0.3.7 release it follows; its version bump is the base of this one |

## Traceability

| Business Case objective / KPI / user story | Reference |
| --- | --- |
| Release of the script that creates a project repeatably | [BC-001] |
| User story US-001 | [US-001] |

## Ownership

| Role | Stakeholder ID (SA) |
| --- | --- |
| Owner | S01 |
| Approving reviewer | S02 |

## Target Date

2027-01-21 — proposed; the Business Case sets no deadline.

## Tasks

| # | Task | Summary | Needs its own Use Case/User Story? | Reference |
| --- | --- | --- | --- | --- |
| 1 | Bump the version to 0.3.8 | Set `VERSION` in `src/lib/constants.sh` to 0.3.8 and the `--version` check in `tests/test-security.sh` to match. Move the entries under `## [Unreleased]` in `CHANGELOG.md` to a dated `## [0.3.8]` entry (the framework pin moves to `v0.17.1`), and leave `## [Unreleased]` empty. | No | |
| 2 | Release v0.3.8 | After the pull request of task 1 is merged, run the Release workflow on `main` with version `0.3.8` and `dry_run` true, read its output, then run it again with `dry_run` false. Check that the tag, the release page and the moving tag `v0` are as in criteria 5 and 6. Starting the second run is S01's decision. | No | |

---

[BC-001]: ../business-case.md
[US-001]: ../user-stories.md
[MIL-016]: ./mil-016-release-0-3-7.md
[2d3932f]: https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/commit/2d3932f135d56411439477dead63a21f0bc35294

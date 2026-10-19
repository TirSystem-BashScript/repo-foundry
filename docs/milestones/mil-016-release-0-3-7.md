# MIL-016 Release 0.3.7

## Metadata
| Key | Value |
| --- | --- |
| ID | MIL-016 |
| CrossReference | [BC-001], [US-001], [MIL-015] |
| Language | en |
| Domain | it |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-10-19 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version | pending |

---

## Purpose

Decide whether the work merged since `v0.3.5` is released. Version 0.3.6 was merged on 2026-10-15 but never tagged, so the last release is still `v0.3.5`. This milestone releases the work as version 0.3.7 and adds what has been done since: the framework pin move to `v0.14.0`, the Appendix page of the wiki that links the documents in `docs/`, and the AI prompt log section of `AGENTS.md`. `CHANGELOG.md` holds these under `## [Unreleased]`. A release is deliberate: the Release workflow runs only on request, defaults to a dry run, and refuses a version that has no entry in `CHANGELOG.md`.

## Deliverable

Version 0.3.7 of `create-project.sh`, released on Gitea: `VERSION` and the `--version` check say 0.3.7; `CHANGELOG.md` has a dated `## [0.3.7]` entry and an empty `## [Unreleased]`; the tag `v0.3.7` and its release page exist, made by the Release workflow from the tip of `main`, and the moving tag `v0` points to it. The `## [0.3.6]` entry stays, as the work of 0.3.6 is part of this release.

The change is a patch release: the only change to the script is its version number. The credentials the script asks for, its host requests and its steps do not change.

## Go / No-Go Criteria

| # | Criterion (objectively checkable) | Go | No-Go |
| --- | --- | --- | --- |
| 1 | `create-project.sh --version` prints `RepoFoundry 0.3.7` | Tests pass | Another version |
| 2 | `CHANGELOG.md` has a `## [0.3.7]` entry with its date that matches the changes since `v0.3.5`, and `## [Unreleased]` holds no entry | Reviewed by S02 | An entry missing, or text left under Unreleased |
| 3 | The Quality run on the tip of `main` is green, and no test fails that passed at `v0.3.5` | Tests pass | A new failure |
| 4 | The Release workflow, run with version `0.3.7` and `dry_run` true, checks the version, the tip of `main` and the changelog entry and writes nothing | Dry run passes | The dry run reports an error |
| 5 | After the run with `dry_run` false, the tag `v0.3.7` and its release page exist on Gitea, and the page text is the changelog entry | Verified on Gitea | No tag, no page, or another text |
| 6 | The moving tag `v0` points to the same commit as `v0.3.7` | Verified on Gitea | `v0` elsewhere |

## Dependencies

| Depends on | Reason |
| --- | --- |
| [MIL-015] | The 0.3.6 version bump and the timeout handling of MIL-014 it carries are released here |

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

2027-01-19 — proposed; the Business Case sets no deadline.

## Tasks

| # | Task | Summary | Needs its own Use Case/User Story? | Reference |
| --- | --- | --- | --- | --- |
| 1 | Bump the version to 0.3.7 | Set `VERSION` in `src/lib/constants.sh` to 0.3.7 and the `--version` check in `tests/test-security.sh` to match. Move the entries under `## [Unreleased]` in `CHANGELOG.md` to a dated `## [0.3.7]` entry, add the framework pin, the wiki Appendix and the `AGENTS.md` section, and leave `## [Unreleased]` empty. | No | |
| 2 | Release v0.3.7 | After the pull request of task 1 is merged, run the Release workflow on `main` with version `0.3.7` and `dry_run` true, read its output, then run it again with `dry_run` false. Check that the tag, the release page and the moving tag `v0` are as in criteria 5 and 6. Starting the second run is S01's decision. | No | |

---

[BC-001]: ../business-case.md
[US-001]: ../user-stories.md
[MIL-015]: ./mil-015-release-0-3-6.md

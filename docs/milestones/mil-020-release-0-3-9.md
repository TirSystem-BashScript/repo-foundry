# MIL-020 Release 0.3.9

## Metadata
| Key | Value |
| --- | --- |
| ID | MIL-020 |
| CrossReference | [BC-001], [US-001], [MIL-017], [MIL-019] |
| Language | en |
| Domain | it |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-10-29 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version | pending |

---

## Purpose

Decide whether the work merged since `v0.3.8` is released as version 0.3.9. Release 0.3.8 ([MIL-017]) is tagged first; it carries the framework pin `v0.17.1` and the `TP` and `AD` register rows. Since the version bump to 0.3.8, `main` has the Gitea token names of the framework ([MIL-019]: `TOKEN_FOR_GITEA_REPO`, with `GITEA_TOKEN` as the older name for one release) and the framework pin `v0.19.0`. `CHANGELOG.md` holds the token change under `## [Unreleased]`, and `VERSION` still says 0.3.8. A release is deliberate: the Release workflow runs only on request, defaults to a dry run, and refuses a version that has no entry in `CHANGELOG.md`.

## Deliverable

Version 0.3.9 of `create-project.sh`, released on Gitea: `VERSION` and the `--version` check say 0.3.9; `CHANGELOG.md` has a dated `## [0.3.9]` entry and an empty `## [Unreleased]`; the tag `v0.3.9` and its release page exist, made by the Release workflow from the tip of `main`, and the moving tag `v0` points to it.

The change is a patch release: it changes which key names the script reads from `.env`, and the older `GITEA_TOKEN` keeps working for this version. Its steps and host requests do not change. [MIL-018] is not part of it and goes into a later version.

## Go / No-Go Criteria

| # | Criterion (objectively checkable) | Go | No-Go |
| --- | --- | --- | --- |
| 1 | `create-project.sh --version` prints `RepoFoundry 0.3.9` | Tests pass | Another version |
| 2 | `CHANGELOG.md` has a `## [0.3.9]` entry with its date that matches the changes since `v0.3.8`, including the framework pin `v0.19.0`, and `## [Unreleased]` holds no entry | Reviewed by S02 | An entry missing, or text left under Unreleased |
| 3 | `v0.3.8` exists before this release is made | Verified on Gitea | No tag `v0.3.8` |
| 4 | The Quality run on the tip of `main` is green, and no test fails that passed at `v0.3.8` | Tests pass | A new failure |
| 5 | The Release workflow, run with version `0.3.9` and `dry_run` true, checks the version, the tip of `main` and the changelog entry and writes nothing | Dry run passes | The dry run reports an error |
| 6 | After the run with `dry_run` false, the tag `v0.3.9` and its release page exist on Gitea, and the page text is the changelog entry | Verified on Gitea | No tag, no page, or another text |
| 7 | The moving tag `v0` points to the same commit as `v0.3.9` | Verified on Gitea | `v0` elsewhere |

## Dependencies

| Depends on | Reason |
| --- | --- |
| [MIL-017] | The 0.3.8 release it follows; its tag must exist first |
| [MIL-019] | The change this release ships |

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

2027-02-02 — proposed; the Business Case sets no deadline.

## Tasks

| # | Task | Summary | Needs its own Use Case/User Story? | Reference |
| --- | --- | --- | --- | --- |
| 1 | Bump the version to 0.3.9 | Set `VERSION` in `src/lib/constants.sh` to 0.3.9 and the `--version` check in `tests/test-security.sh` to match. Move the entries under `## [Unreleased]` in `CHANGELOG.md` to a dated `## [0.3.9]` entry (the Gitea token names, and the framework pin `v0.19.0`), and leave `## [Unreleased]` empty. | No | |
| 2 | Release v0.3.9 | After the pull request of task 1 is merged and `v0.3.8` exists, run the Release workflow on `main` with version `0.3.9` and `dry_run` true, read its output, then run it again with `dry_run` false. Check that the tag, the release page and the moving tag `v0` are as in criteria 6 and 7. Starting the second run is S01's decision. | No | |

---

[BC-001]: ../business-case.md
[US-001]: ../user-stories.md
[MIL-017]: ./mil-017-release-0-3-8.md
[MIL-019]: ./mil-019-gitea-token-names.md
[MIL-018]: ./mil-018-delete-branch-after-merge.md

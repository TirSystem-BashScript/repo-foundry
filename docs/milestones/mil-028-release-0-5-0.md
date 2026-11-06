# MIL-028 Release 0.5.0

## Metadata
| Key | Value |
| --- | --- |
| ID | MIL-028 |
| CrossReference | [BC-001], [US-001], [MIL-026], [MIL-027] |
| Language | en |
| Domain | it |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-11-06 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version | [e961872] |

---

## Purpose

Decide whether the work merged since `v0.4.0` is released as version 0.5.0. `main` now turns on "Delete pull request branch after merge by default" on a new Gitea repository ([MIL-018]) and requires signed commits in the branch protection rule by default ([MIL-027]). One new behaviour and one changed default make it a minor release. `CHANGELOG.md` holds both changes under `## [Unreleased]` and `VERSION` still says 0.4.0. The changed default affects a user who has no signing set up: the entry says so and names the key that turns it off (`PROTECTED_REQUIRE_SIGNED_COMMITS=false`). A release is deliberate: the Release workflow runs first as a dry run, and the run that writes the tag is S01's decision.

## Deliverable

Version 0.5.0 of `create-project.sh`, released on Gitea: `VERSION` and the `--version` check say 0.5.0; `CHANGELOG.md` has a dated `## [0.5.0]` entry and an empty `## [Unreleased]`; the tag `v0.5.0` and its release page exist, made by the Release workflow from the tip of `main`, and the moving tag `v0` points to it.

The entry keeps the Added and Changed groups of `## [Unreleased]`, in the order the changelog rules set. The framework pin stays as it is.

## Go / No-Go Criteria

| # | Criterion (objectively checkable) | Go | No-Go |
| --- | --- | --- | --- |
| 1 | `create-project.sh --version` prints `RepoFoundry 0.5.0` | Tests pass | Another version |
| 2 | `CHANGELOG.md` has a `## [0.5.0]` entry with its date that matches the changes since `v0.4.0`, and `## [Unreleased]` holds no entry | Reviewed by S02 | An entry missing, or text left under Unreleased |
| 3 | The latest tag before this release is `v0.4.0` | Verified on Gitea | Another latest tag |
| 4 | The Quality run on the tip of `main` is green, and no test fails that passed at `v0.4.0` | Tests pass | A new failure |
| 5 | The Release workflow, run with version `0.5.0` and `dry_run` true, checks the version, the tip of `main` and the changelog entry and writes nothing | Dry run passes | The dry run reports an error |
| 6 | After the run with `dry_run` false, the tag `v0.5.0` and its release page exist on Gitea, and the page text is the changelog entry | Verified on Gitea | No tag, no page, or another text |
| 7 | The moving tag `v0` points to the same commit as `v0.5.0` | Verified on Gitea | `v0` elsewhere |

## Dependencies

| Depends on | Reason |
| --- | --- |
| [MIL-026] | The previous release, 0.4.0, from which this one counts |
| [MIL-027] | The last change this release ships; [MIL-018] is merged too |

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

2027-03-09 — proposed; the Business Case sets no deadline.

## Tasks

| # | Task | Summary | Needs its own Use Case/User Story? | Reference |
| --- | --- | --- | --- | --- |
| 1 | Bump the version to 0.5.0 | Set `VERSION` in `src/lib/constants.sh` to 0.5.0 and the `--version` check in `tests/test-security.sh` to match. Move the entries under `## [Unreleased]` in `CHANGELOG.md` to a dated `## [0.5.0]` entry (the Added and the Changed group) and leave `## [Unreleased]` empty. | No | |
| 2 | Release v0.5.0 | After the pull request of task 1 is merged, run the Release workflow on `main` with version `0.5.0` and `dry_run` true, read its output, then run it again with `dry_run` false. Check that the tag, the release page and the moving tag `v0` are as in criteria 6 and 7. Starting the second run is S01's decision. | No | |

---

[BC-001]: ../business-case.md
[US-001]: ../user-stories.md
[MIL-018]: ./mil-018-delete-branch-after-merge.md
[MIL-026]: ./mil-026-release-0-4-0.md
[MIL-027]: ./mil-027-signed-commits-by-default.md
[e961872]: https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/commit/e961872aa0968b3f058166e7213a5ee69ff6c1c4

# MIL-026 Release 0.4.0

## Metadata
| Key | Value |
| --- | --- |
| ID | MIL-026 |
| CrossReference | [BC-001], [US-001], [MIL-020], [MIL-025] |
| Language | en |
| Domain | it |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-11-05 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version | [3edc44e] |

---

## Purpose

Decide whether the work merged since `v0.3.9` is released as version 0.4.0. `main` now sets a branch protection rule on a new Gitea repository ([MIL-021]), gives an existing repository the same rule with `--protect OWNER/NAME` ([MIL-022]), accepts `TOKEN_FOR_GITEA_RELEASE` in `.env` ([MIL-023]), can require signed commits ([MIL-024]) and always blocks a merge on rejected reviews, review requests, an outdated branch and for administrators ([MIL-025]). New behaviour, a new command line option and new `config.env` keys make it a minor release, not a patch. `CHANGELOG.md` holds these changes under `## [Unreleased]` and `VERSION` still says 0.3.9. A release is deliberate: the Release workflow runs first as a dry run, and the run that writes the tag is S01's decision.

## Deliverable

Version 0.4.0 of `create-project.sh`, released on Gitea: `VERSION` and the `--version` check say 0.4.0; `CHANGELOG.md` has a dated `## [0.4.0]` entry and an empty `## [Unreleased]`; the tag `v0.4.0` and its release page exist, made by the Release workflow from the tip of `main`, and the moving tag `v0` points to it.

The entry lists the five branch protection changes under Added and the changelog check of pull requests in the release workflow under Changed. The framework pin stays at `v0.19.0`. A new Gitea repository now refuses a direct push to `main`; the entry says so, because the first commit of a new project must go by a pull request.

## Go / No-Go Criteria

| # | Criterion (objectively checkable) | Go | No-Go |
| --- | --- | --- | --- |
| 1 | `create-project.sh --version` prints `RepoFoundry 0.4.0` | Tests pass | Another version |
| 2 | `CHANGELOG.md` has a `## [0.4.0]` entry with its date that matches the changes since `v0.3.9`, and `## [Unreleased]` holds no entry | Reviewed by S02 | An entry missing, or text left under Unreleased |
| 3 | The latest tag before this release is `v0.3.9` | Verified on Gitea | Another latest tag |
| 4 | The Quality run on the tip of `main` is green, and no test fails that passed at `v0.3.9` | Tests pass | A new failure |
| 5 | The Release workflow, run with version `0.4.0` and `dry_run` true, checks the version, the tip of `main` and the changelog entry and writes nothing | Dry run passes | The dry run reports an error |
| 6 | After the run with `dry_run` false, the tag `v0.4.0` and its release page exist on Gitea, and the page text is the changelog entry | Verified on Gitea | No tag, no page, or another text |
| 7 | The moving tag `v0` points to the same commit as `v0.4.0` | Verified on Gitea | `v0` elsewhere |

## Dependencies

| Depends on | Reason |
| --- | --- |
| [MIL-020] | The previous release, 0.3.9, from which this one counts |
| [MIL-025] | The last change this release ships; all of [MIL-021] to [MIL-025] are merged first |

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

2027-03-02 — proposed; the Business Case sets no deadline.

## Tasks

| # | Task | Summary | Needs its own Use Case/User Story? | Reference |
| --- | --- | --- | --- | --- |
| 1 | Bump the version to 0.4.0 | Set `VERSION` in `src/lib/constants.sh` to 0.4.0 and the `--version` check in `tests/test-security.sh` to match. Move the entries under `## [Unreleased]` in `CHANGELOG.md` to a dated `## [0.4.0]` entry (the five branch protection changes under Added, the changelog check of pull requests under Changed, and a line that a new Gitea repository refuses a direct push to `main`), and leave `## [Unreleased]` empty. | No | |
| 2 | Release v0.4.0 | After the pull request of task 1 is merged, run the Release workflow on `main` with version `0.4.0` and `dry_run` true, read its output, then run it again with `dry_run` false. Check that the tag, the release page and the moving tag `v0` are as in criteria 6 and 7. Starting the second run is S01's decision. | No | |

---

[BC-001]: ../business-case.md
[US-001]: ../user-stories.md
[MIL-020]: ./mil-020-release-0-3-9.md
[MIL-021]: ./mil-021-protect-default-branch.md
[MIL-022]: ./mil-022-protect-existing-repository.md
[MIL-023]: ./mil-023-release-token-key.md
[MIL-024]: ./mil-024-require-signed-commits.md
[MIL-025]: ./mil-025-block-merge-rules.md
[3edc44e]: https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/commit/3edc44e7fee8a7570b47c9f08a6953c268d9eb9b
